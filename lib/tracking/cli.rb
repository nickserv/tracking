#Tracking's command line interface (view).

#view module methods
module Tracking
	module CLI

		extend self

		#displays the entire list
		def display_tasks
			#read data file
			data = []
			file_length = $data_file.readlines.size
			$data_file.seek(0)
			$data_file.each_with_index do |line, index=0|
				if index+1 > file_length - $config[:lines]
					data.push line.split("|")
				end
			end
			#display data
			if data.length > 0
				puts "+-------+--------------------------------------+"
				for i in 0..data.length-1
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
					puts line
				end
				puts "+-------+--------------------------------------+"
			else
				#puts pad("You haven't started any tasks yet.", 20)
				puts <<EOF
+----------------------------------------------+
| You haven't started any tasks yet! :(        |
|                                              |
| Run this to begin your first task:           |
|     tracking starting some work              |
+----------------------------------------------+
EOF
			end
		end

		#prints help for working with tracking
		def help
			puts <<EOF
Usage:
		display all tasks
  <task>:       add a new task with the given text
  -c, --clear   delete all tasks
  -d, --delete  delete the latest task
  -e, --edit    open data file in your default text editor
  -h, --help    display this help information"
EOF
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

		#parse options for the command line interface
		def parse
			if ARGV.length == 0
				display_tasks
			else
				case ARGV[0]
				when "-c","--clear"
					puts "list cleared"
					List.clear
				when "-d","--delete"
					List.remove
					display_tasks
				when "-e","--edit"
					List.edit
				when "-h","--help"
					List.help
				else
					List.add ARGV.join(" ")
					display_tasks
				end
			end
		end

	end
end
