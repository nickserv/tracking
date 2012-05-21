#!/usr/bin/env ruby

#imports
require "time"

#data file
$filename = ENV["HOME"]+"/.tracking"

#methods for manipulating and displaying the list of data
module List

	#prints the entire list
	def self.print
		puts "tracking display (run \"tracking help\" for help)"
		File.open($filename,"r").each do |l|
			line = l.split("|")
			if line[0].chomp != ""
				time = Time.parse(line[0])
				puts time.strftime("%H:%M")+" "+line[1]
			end
		end
	end

	#adds an item to the list
	def self.add item
		File.open($filename,"a") do |f|
			newline = "\n"
			if File.zero?($filename)
				newline = ""
			end
			date = Time.now.to_s
			f.write(newline+date+"|"+item.chomp)
		end
	end

	#clears the entire list
	def self.clear
		File.open($filename,"w") do |f|
			f.write ""
		end
	end

	#opens the list data file in a text editor
	def self.edit
		system ENV["EDITOR"] + " " + $filename
	end

	#prints help for working with tracking
	def self.help
		puts "tracking commands
t:        displays all tracked tasks
t <task>: adds a new task with the given text
t clear:  deletes all tracked tasks
t edit:   opens your data file in the default text editor
t help:   display this help information"
	end

end

#command line interface
if ARGV.length == 0
	List.print
else
	if ARGV[0] == "clear"
		puts "list cleared"
		List.clear
	elsif ARGV[0] == "edit"
		List.edit
	elsif ARGV[0] == "help"
		List.help
	else
		List.add ARGV.join(" ")
		List.print
	end
end
