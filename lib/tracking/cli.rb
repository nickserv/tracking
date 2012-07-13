#Tracking's command line interface (view).

#imports
require "optparse"

#view module methods
module Tracking
	module CLI

		extend self

		#displays the entire list
		def display_tasks
			#horizontal border for the top or bottom of tracking's display
			horizontal_border = "+-------+--------------------------------------+"
			#intro message, displayed when no valid tasks are found
			introduction = <<EOF
+----------------------------------------------+
| You haven't started any tasks yet! :(        |
|                                              |
| Run this to begin your first task:           |
|     tracking starting some work              |
+----------------------------------------------+
EOF
			#read data file
			data = []
			valid_lines = 0
			invalid_lines = 0
			file_length = $data_file.readlines.size
			$data_file.seek(0)
			$data_file.each_with_index do |line, index=0|
				if index+1 > file_length - $config[:lines]
					data << line
				end
			end
			#display data
			for i in 0..data.length-1
				if data[i].length == 2
					#grab and reformat data
					time = Time.parse(data[i][0]).strftime("%H:%M")
					task = data[i][1].chomp
					if i < data.length - 1
						elapsed = List.get_elapsed_time(Time.parse(data[i][0]), Time.parse(data[i+1][0]))
					else
						elapsed = List.get_elapsed_time(Time.parse(data[i][0]), Time.now())
					end
					tasks = split_task(task)
					#ready data for display
					line = "| #{pad(time,5)} | #{pad(tasks[0],20)} | #{pad(elapsed,13,:right)} |"
					tasks[1..-1].each do |x|
						line += "\n| #{pad("",5)} | #{pad(x,20)} | #{pad("",13,:right)} |"
					end
					#print data
					puts horizontal_border if valid_lines == 0
					puts line
					valid_lines += 1
				else
					invalid_lines += 1
				end
			end
			#display intro, if needed
			if valid_lines > 0
				puts horizontal_border
			else
				puts introduction
			end
			#display warnings, if needed
			if invalid_lines == 1
				warn "Error: 1 invalid line found in data file."
			elsif invalid_lines > 1
				warn "Error: #{invalid_lines} invalid lines found in data file."
			end
		end

		#pads tasks with whitespace to align them for display
		def pad(string, length, align=:left)
			if align==:right
				until string.length >= length
					string.insert(0," ")
				end
			#elsif align==:center
				#do stuff
			else
				until string.length >= length
					string += " "
				end
			end
			return string
		end

		#word wraps tasks for display
		def split_task(task)
			width = 20
			split = Array.new
			if task.length > width #if the task needs to be split
				task_words = task.split(" ")
				line = ""
				task_words.each do |x|
					if x.length > width #if the word needs to be split
						#add the start of the word onto the first line (even if it has already started)
						while line.length < width
							line += x[0]
							x = x[1..-1]
						end
						split << line
						#split the rest of the word up onto new lines
						split_word = x.scan(%r[.{1,#{width}}])
						split_word[0..-2].each do |word|
							split << word
						end
						line = split_word.last+" "
					elsif (line + x).length > width-1 #if the word would fit alone on its own line
						split << line.chomp
						line = x
					else #if the word can be added to this line
						line += x + " "
					end
				end
				split << line
			else #if the task doesn't need to be split
				split = [task]
			end
			#give back the split line
			return split
		end

		#use option parser to parse command line arguments
		def parse
			#options = {}
			done = false

			OptionParser.new do |opts|
				version_path = File.expand_path("../../VERSION", File.dirname(__FILE__))
				opts.version = File.exist?(version_path) ? File.read(version_path) : ""
				opts.banner = "Usage: tracking [mode]"
				opts.separator "                                     display all tasks"
				opts.separator "    <task>                           start a new task with the given text"
				opts.on("-c", "--clear", "delete all tasks" ) do
					List.clear
					puts "List cleared."
					done = true
					return
				end
				opts.on("-d", "--delete", "delete the last task" ) do
					List.remove
					display_tasks
					done = true
					return
				end
				opts.on("-e", "--edit", "open data file in a text editor" ) do
					List.edit
					done = true
					return
				end
				opts.on("-h", "--help", "displays this help information" ) do
					puts opts
					done = true
					return
				end
			end.parse!

			if not done
				if ARGV.count == 0
					#display all tasks
					display_tasks
				else
					#start a new task
					List.add ARGV.join(" ")
					display_tasks
				end
			end
		end

	end
end
