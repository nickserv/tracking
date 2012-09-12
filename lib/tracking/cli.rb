require 'optparse'
require 'colorize'

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
					is_current = (task_index + 1 == tasks.length)
					display_task(task)
				end
			else
				display_object :intro
			end
			display_object :bottom
			# Display a warning, if needed
=begin
			if invalid_lines > 0
				warn "Error: #{invalid_lines} invalid line#{'s' if invalid_lines > 1} found in data file."
			end
=end
		end

		# Displays a single formatted task in the command line
		#
		# @param [Task] task the task to display
		def display_task(task)
			word_wrap(task.name).split("\n").each_with_index do |name_line, line_index|
				col_1 = pad(line_index==0 ? task.start_time : nil, 5)
				col_2 = pad(name_line, @name_width)
				col_3 = pad(line_index==0 ? task.elapsed_time : nil, @elapsed_time_width)
				if task.current? and Config[:color_current_task]
					col_1,col_2,col_3 = col_1.yellow,col_2.yellow,col_3.yellow
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
				else
					return string
				end
			end
		end

		# Word wraps text into multiple lines for display (based on the user's task
		# width setting)
		#
		# This implementation is borrowed from
		# ActionView::Helpers::TextHelper#word_wrap in Rails (commit 7b31a43085).
		#
		# @see https://github.com/rails/rails/blob/master/actionpack/lib/action_view/helpers/text_helper.rb
		#
		# @param [String] text the text to wrap
		#
		# @return [String] the wrapped text (with newline characters)
		def word_wrap(text)
			text.split("\n").collect do |line|
				line.length > Config[:task_width] ? line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1\n").strip : line
			end * "\n"
		end

		# Use option parser to parse command line arguments and run the selected
		# command with its selected options
		def parse
			#options = {}
			done = false

			OptionParser.new do |opts|
				# Setup
				version_path = File.expand_path('../../VERSION', File.dirname(__FILE__))
				opts.version = File.exist?(version_path) ? File.read(version_path) : ''
				# Start of help text
				opts.banner = 'Usage: tracking [mode]'
				opts.separator '                                     display recent tasks'
				opts.separator '    <task description>               start a new task with the given text (spaces allowed)'
				# Modes
				opts.on('-a', '--all', 'display all tasks') do
					display(:max => :all)
					return
				end
				opts.on('-n', '--number integer', 'display n tasks') do |number_str|
					display(:max => number_str.to_i)
					return
				end
				opts.on('-r', '--rename', 'rename the last task') do
					List.rename ARGV.join(' ').gsub("\t",'')
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
			end.parse!

			# Basic modes (display and add)
			if ARGV.count == 0
				# Display all tasks
				display
			else
				# Start a new task
				List.add ARGV.join(' ').gsub("\t",'')
				display
			end
		end

	end
end
