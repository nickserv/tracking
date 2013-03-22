require 'optparse'
require 'colorize'
require 'terminal-table'

module Tracking
  # Contains methods for displaying the list in a command line and parsing
  # command line arguments.
  module CLI
    extend self

    # Width of the first column (start time)
    @start_time_width = 5

    # Width of the second column (name)
    @name_width = Config[:task_width]

    # Width of the third column (elapsed time)
    @elapsed_time_width = Task.elapsed_time_length

    # Displays part of the list in the command line
    #
    # @param [Hash] options the options to use for retrieving tasks (passed to
    # List#get)
    def display options={}
      display_object :top
      tasks = List.get options
      if tasks.length > 0
        tasks.each_with_index do |task, task_index|
          display_task(task)
        end
      else
        display_object :intro
      end
      display_object :bottom
    end

    # Displays a single formatted task in the command line
    #
    # @param [Task] task the task to display
    def display_task(task)
      split_task(task.name).each_with_index do |name_line, line_index|
        col_1 = pad((task.start_time if line_index==0), 5)
        col_2 = pad(name_line, @name_width)
        col_3 = pad((task.elapsed_time if line_index==0), @elapsed_time_width)

        if task.current? and Config[:color_current_task]
          current_task_color = Config[:current_task_color]
          current_task_color = Config.defaults[:current_task_color] unless String.colors.include? current_task_color

          col_1 = col_1.colorize current_task_color
          col_2 = col_2.colorize current_task_color
          col_3 = col_3.colorize current_task_color
        end

        puts "| #{col_1} | #{col_2} | #{col_3} |"
      end
    end

    # Displays commonly used text objects in the command line
    #
    # @param type the type of text object to display (:top/:bottom/:intro)
    def display_object type
      horizontal_border = "+-------+-#{'-'*@name_width}-+-#{'-'*@elapsed_time_width}-+"
      case type
      when :top
        puts horizontal_border
        if Config[:show_header]
          puts "| start | #{pad('task', @name_width, :center)} | #{pad('elapsed', @elapsed_time_width, :center)} |"
          puts horizontal_border
        end
      when :bottom
        puts horizontal_border
      when :intro
        intro_text = <<-EOF
You haven't started any tasks yet! :(

Run this to begin your first task:
  tracking starting some work
        EOF
        intro_text.each_line do |line|
          puts "|       | #{pad(line.chomp, @name_width)} | #{pad(nil, @elapsed_time_width)} |"
        end
      end
    end

    # Pads tasks with whitespace to align them for display
    #
    # @param [String] string the string to pad
    # @param [Integer] length the length of the resultant string
    # @param [Symbol] align the alignment of the start string within the end
    # string (:left/:right/:center)
    # @return [String] the padded string
    def pad(string, length, align=:left)
      if string == nil
        return ' ' * length
      elsif string.length >= length
        return string
      else
        difference = (length - string.length).to_f
        case align
        when :left
          return string + ' ' * difference
        when :right
          return ' ' * difference + string
        when :center
          return ' '*(difference/2).floor + string + ' '*(difference/2).ceil
        end
      end
    end

    # Word wraps tasks into multiple lines for display (based on the user's task
    # width setting)
    #
    # @param [String] task the task string to split up
    # @return [Array] an array of strings, each containing an individual line of
    # wrapped text
    def split_task task

      # If the task fits
      if task.length <= Config[:task_width]
        return [task]

      # If the task needs to be split
      else
        words = task.split(' ')
        split = []
        line = ''
        words.each do |word|

          # If the word needs to be split
          if word.length > Config[:task_width]
            # Add the start of the word onto the first line (even if it has
            # already started)
            while line.length < Config[:task_width]
              line += word[0]
              word = word[1..-1]
            end
            split << line
            # Split the rest of the word up onto new lines
            split_word = word.scan(%r[.{1,#{Config[:task_width]}}])
            split_word[0..-2].each do |word_section|
              split << word_section
            end
            line = split_word.last

          # If the word would fit on a new line
          elsif (line + word).length > Config[:task_width]
            split << line.chomp
            line = word

          # If the word can be added to this line
          else
            line += word
          end

          # Add a space to the end of the last word, if it would fit
          line += ' ' if line.length != Config[:task_width]

        end
        split << line
        return split
      end
    end

    # Gets a string of text from ARGV. Lets the user use spaces in strings
    # without typing quotes around his/her text. Also removes tab characters
    # from input data, so they would not interfere with the CSV file (which is
    # separated with the tab character).
    #
    # @return input text from ARGV
    def text_from_args
      return ARGV.join(' ').gsub("\t",'')
    end

    # Use option parser to parse command line arguments and run the selected
    # command with its selected options
    #
    # @param [Array] args the command line arguments passed to OptionParser
    # (this should only need to be overridden for testing)
    def parse args=ARGV
      OptionParser.new do |opts|
        # Setup
        version_path = File.expand_path('../../VERSION', File.dirname(__FILE__))
        opts.version = File.exist?(version_path) ? File.read(version_path) : ''
        # Start of help text
        opts.banner = 'Usage: tracking [mode]'
        opts.separator '                                     display recent tasks'
        opts.separator '    <task description>               start a new task with the given text (spaces allowed)'
        # Modes
        opts.on('-f', '--find', 'display all tasks that match a search query') do
          display(:query => text_from_args)
          return
        end
        opts.on('-a', '--all', 'display all tasks') do
          display(:max => :all)
          return
        end
        opts.on('-n', '--number integer', 'display n tasks') do |number_str|
          display(:max => number_str.to_i)
          return
        end
        opts.on('-r', '--rename', 'rename the last task') do
          List.rename text_from_args
          display
          return
        end
        opts.on('-d', '--delete', 'delete the last task') do
          List.delete
          display
          return
        end
        opts.on('-c', '--clear', 'delete all tasks') do
          List.clear
          puts 'List cleared.'
          return
        end
        opts.on('-h', '--help', 'display this help information') do
          puts opts
          return
        end
      end.parse! args

      # Basic modes (display and add)
      if args.count == 0
        # Display all tasks
        display
      else
        # Start a new task
        List.add args.join(' ').gsub("\t",'')
        display
      end
    end

  end
end
