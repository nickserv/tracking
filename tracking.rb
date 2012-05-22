#!/usr/bin/env ruby

#imports
require "time"

#data file
$filename = ENV["HOME"]+"/.tracking"
$settings = Hash.new();
$settings["first_line"]  = "+-------+------------------------------+"
$settings["last_line"]   = "+-------+------------------------------+"
$settings["line_start"]  = "| "
$settings["line_middle"] = " | "
$settings["line_end"]    = " |"
$settings["line_length"] = 40

#methods for manipulating and displaying the list of data
module List

	#prints the entire list
	def self.print
		puts $settings["first_line"]
		File.open($filename,"r").each do |l|
			line = l.split("|")
			if line[0].chomp != ""
				time = Time.parse(line[0])
				line = $settings["line_start"]+time.strftime("%H:%M")+$settings["line_middle"]+line[1].chomp
				until line.length == $settings["line_length"]-$settings["line_end"].length
					line += " "
				end
				line += $settings["line_end"]
				puts line
			end
		end
		puts $settings["last_line"]
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

	#removes an item from the list
	def self.remove
		lines = File.readlines($filename)
		lines.pop
		File.open($filename, "w") do |f| 
			lines.each do |line|
				f.puts(line)
			end
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
	elsif ARGV[0] == "rm"
		List.remove
		List.print
	elsif ARGV[0] == "edit"
		List.edit
	elsif ARGV[0] == "help"
		List.help
	else
		List.add ARGV.join(" ")
		List.print
	end
end
