#Tracking's command line interface (view).

#imports
require "optparse"

#view module methods
module Tracking
	module CLI

		extend self

		#displays the entire list
		def display
			#length of strings produced by the current elapsed time format
			elapsed_time_length = List.get_elapsed_time(Time.now, Time.now).length
			#horizontal border for the top or bottom of tracking's display
			horizontal_border = "+-------+-#{"-"*Config[:task_width]}-+-#{"-"*elapsed_time_length}-+"
			#header row describing tracking's display columns
			header = "| start | #{pad("task", Config[:task_width], :center)} | #{pad("elapsed", elapsed_time_length, :center)} |"
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
			data = []
			valid_lines = 0
			invalid_lines = 0
			data_file = CSV.open($data_file, "r", $csv_options)
			file_length = data_file.readlines.size
			data_file.seek(0)
			data_file.each_with_index do |line, index=0|
				if index+1 > file_length - Config[:lines]
					data << line
				end
			end
			#display data
			for i in 0..data.length-1
				if data[i].length == 2
					begin
						#grab and reformat data
						time_string = Time.parse(data[i][0]).strftime("%H:%M")
						task_string = data[i][1].chomp
						start_time = Time.parse(data[i][0])
						end_time = i<data.length-1 ? Time.parse(data[i+1][0]) : Time.now
						elapsed_string = List.get_elapsed_time(start_time,end_time)
						#ready data for display
						task_split = split_task task_string
						line = "| #{pad(time_string,5)} | #{pad(task_split[0],Config[:task_width])} | #{elapsed_string} |"
						task_split[1..-1].each do |x|
							line += "\n| #{pad("",5)} | #{pad(x,Config[:task_width])} | #{pad("",elapsed_time_length)} |"
						end
						#print data
						if valid_lines == 0
							puts horizontal_border
							if Config[:show_header]
								puts header
								puts horizontal_border
							end
						end
						puts line
						valid_lines += 1
					rescue
						invalid_lines += 1
					end
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
			case align
			when :left
				until string.length >= length
					string += " "
				end
			when :right
				until string.length >= length
					string.insert(0," ")
				end
			when :center
				current_side = :left
				until string.length >= length
					string = pad(string, string.length+1, current_side)
					case current_side
					when :left
						current_side = :right
					when :right
						current_side = :left
					end
				end
			end
			return string
		end

		#word wraps tasks for display
		def split_task(task)
			split = Array.new
			if task.length > Config[:task_width] #if the task needs to be split
				task_words = task.split(" ")
				line = ""
				task_words.each do |x|
					if x.length > Config[:task_width] #if the word needs to be split
						#add the start of the word onto the first line (even if it has already started)
						while line.length < Config[:task_width]
							line += x[0]
							x = x[1..-1]
						end
						split << line
						#split the rest of the word up onto new lines
						split_word = x.scan(%r[.{1,#{Config[:task_width]}}])
						split_word[0..-2].each do |word|
							split << word
						end
						line = split_word.last+" "
					elsif (line + x).length > Config[:task_width]-1 #if the word would fit alone on its own line
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
				opts.separator "                                     display tasks"
				opts.separator "    <task description>               start a new task with the given text (spaces allowed)"
				opts.on("-c", "--clear", "delete all tasks") do
					List.clear
					puts "List cleared."
					done = true
					return
				end
				opts.on("-d", "--delete", "delete the last task") do
					List.delete
					display
					done = true
					return
				end
				opts.on("-h", "--help", "display this help information") do
					puts opts
					done = true
					return
				end
			end.parse!

			if not done
				if ARGV.count == 0
					#display all tasks
					display
				else
					#start a new task
					List.add ARGV.join(" ").gsub("\t","")
					display
				end
			end
		end

	end
end
