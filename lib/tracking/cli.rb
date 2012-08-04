#tracking's command line interface (view)

#imports
require 'optparse'

#view module methods
module Tracking
	module CLI

		extend self

		#displays the entire list
		def display
			#length of strings produced by the current elapsed time format
			elapsed_time_length = List.get_elapsed_time(Time.now, Time.now).length
			#horizontal border for the top or bottom of tracking's display
			horizontal_border = "+-------+-#{'-'*Config[:task_width]}-+-#{'-'*elapsed_time_length}-+"
			#header row describing tracking's display columns
			header = "| start | #{pad('task', Config[:task_width], :center)} | #{pad('elapsed', elapsed_time_length, :center)} |"
			#intro message, displayed when no valid tasks are found
			introduction = <<EOF
+---------------------------------------+
| You haven't started any tasks yet! :( |
|                                       |
| Run this to begin your first task:    |
|     tracking starting some work       |
+---------------------------------------+
EOF
			#read data file
			tasks = List.get
			first_task = true
			#display data
			tasks.each_with_index do |task, i|
				#grab and reformat data
				time_string = Time.parse(task[0]).strftime('%H:%M')
				task_string = task[1].chomp
				start_time = Time.parse(task[0])
				end_time = i<tasks.length-1 ? Time.parse(tasks[i+1][0]) : Time.now
				elapsed_string = List.get_elapsed_time(start_time,end_time)
				#format data into lines
				lines = []
				split_task(task_string).each_with_index do |task_line, i|
					col_1 = pad(i==0 ? time_string : nil, 5)
					col_2 = pad(task_line, Config[:task_width])
					col_3 = pad(i==0 ? elapsed_string : nil, elapsed_time_length)
					lines << "| #{col_1} | #{col_2} | #{col_3} |"
				end
				#display lines
				if first_task
					puts horizontal_border
					if Config[:show_header]
						puts header
						puts horizontal_border
					end
					first_task = false
				end
				lines.each { |line| puts line }
			end
			#display intro, if needed
			if tasks.length > 0
				puts horizontal_border
			else
				puts introduction
			end
			#display a warning, if needed
=begin
			if invalid_lines > 0
				warn "Error: #{invalid_lines} invalid line#{'s' if invalid_lines > 1} found in data file."
			end
=end
		end

		#pads tasks with whitespace to align them for display
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

		#word wraps tasks for display
		def split_task task

			#if the task fits
			if task.length <= Config[:task_width]
				return [task]

			#if the task needs to be split
			else
				words = task.split(' ')
				split = []
				line = ''
				words.each do |word|

					#if the word needs to be split
					if word.length > Config[:task_width]
						#add the start of the word onto the first line (even if it has already started)
						while line.length < Config[:task_width]
							line += word[0]
							word = word[1..-1]
						end
						split << line
						#split the rest of the word up onto new lines
						split_word = word.scan(%r[.{1,#{Config[:task_width]}}])
						split_word[0..-2].each do |word_section|
							split << word_section
						end
						line = split_word.last

					#if the word would fit on a new line
					elsif (line + word).length > Config[:task_width]
						split << line.chomp
						line = word

					#if the word can be added to this line
					else
						line += word
					end

					#add a space to the end of the last word, if it would fit
					line += ' ' if line.length != Config[:task_width]

				end
				split << line
				return split
			end
		end

		#use option parser to parse command line arguments
		def parse
			#options = {}
			done = false

			OptionParser.new do |opts|
				#setup
				version_path = File.expand_path('../../VERSION', File.dirname(__FILE__))
				opts.version = File.exist?(version_path) ? File.read(version_path) : ''
				#start of help text
				opts.banner = 'Usage: tracking [mode]'
				opts.separator '                                     display tasks'
				opts.separator '    <task description>               start a new task with the given text (spaces allowed)'
				#modes
				opts.on('-c', '--clear', 'delete all tasks') do
					List.clear
					puts 'List cleared.'
					done = true
					return
				end
				opts.on('-d', '--delete', 'delete the last task') do
					List.delete
					display
					done = true
					return
				end
				opts.on('-h', '--help', 'display this help information') do
					puts opts
					done = true
					return
				end
			end.parse!

			#basic modes (display and add)
			if not done
				if ARGV.count == 0
					#display all tasks
					display
				else
					#start a new task
					List.add ARGV.join(' ').gsub("\t",'')
					display
				end
			end
		end

	end
end
