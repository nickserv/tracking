#!/usr/bin/env ruby

#imports
require "time"

#data file
$datafile = ENV["HOME"]+"/.tracking"
$settings = {
	:lines       => 10,
	:first_line  => "+-------+--------------------------------------+",
	:last_line   => "+-------+--------------------------------------+"
}

#methods for manipulating and displaying the list of data
module List

	#displays the entire list
	def self.display
		#read data file
		data = []
		file_length = 0
		File.open($datafile) {|f| file_length = f.read.count("\n")}
		File.open($datafile).each_with_index do |line, index=0|
			if index+1 > file_length - $settings[:lines]
				data.push line.split("|")
			end
		end
		#display data
		puts $settings[:first_line]
		for i in 0..data.length-1
			#grab and reformat data
			time = Time.parse(data[i][0]).strftime("%H:%M")
			task = data[i][1].chomp
			if i < data.length - 1
				elapsed = getElapsedTime(Time.parse(data[i][0]), Time.parse(data[i+1][0]))
			else
				elapsed = getElapsedTime(Time.parse(data[i][0]), Time.now())
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
		puts $settings[:last_line]
	end

	#adds an item to the list
	def self.add item
		File.open($datafile,"a") do |f|
			newline = "\n"
			if File.zero?($datafile)
				newline = ""
			end
			date = Time.now.to_s
			f.write(newline+date+"|"+item.chomp)
		end
	end

	#removes an item from the list
	def self.remove
		lines = File.readlines($datafile)
		lines.pop
		File.open($datafile, "w") do |f| 
			lines.each do |line|
				f.puts(line)
			end
		end
	end

	#clears the entire list
	def self.clear
		File.open($datafile,"w") do |f|
			f.write ""
		end
	end

	#opens the list data file in a text editor
	def self.edit
		system ENV["EDITOR"] + " " + $datafile
	end

	#prints help for working with tracking
	def self.help
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

end

def getElapsedTime(time1, time2)
	s = (time2 - time1).floor
	if s >= 60
		m = s/60
		s = s%60
		if m >= 60
			h = m/60
			m = m%60
			if h >= 24
				d = h/24
				h = h%24
			end
		end
	end
	display = ""
	if d
		display += "#{d.to_s}d "
	end
	if h
		display += "#{h.to_s}h "
	end
	if m
		display += "#{m.to_s}m "
	end
	if s
		display += "#{s.to_s}s"
	end
	return display
end

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

def split_task(task)
	split = Array.new
	if task.length > 20 
		task_words = task.split(" ")
		line = ""
		task_words.each do |x|
			if x.length > 20 
				split_word = x.scan(%r[.{1,20}])
				split_word[0..-2].each do |word|
					split << word
				end
				line = split_word.last+" "
			elsif (line + x).length > 20
				split << line.chomp
				line = x + " "
			else
				line += x + " "
			end
		end
		split << line
	else
		split = [task]
	end
	return split
end

#command line interface
if ARGV.length == 0
	List.display
else
	case ARGV[0]
	when "-c","--clear"
		puts "list cleared"
		List.clear
	when "-d","--delete"
		List.remove
		List.display
	when "-e","--edit"
		List.edit
	when "-h","--help"
		List.help
	else
		List.add ARGV.join(" ")
		List.display
	end
end
