#!/usr/bin/env ruby

#imports
require "time"

#data file
$datafile = ENV["HOME"]+"/.tracking"
$settings = {
	"lines"       => 10,
	"first_line"  => "+-------+------------------------------+",
	"last_line"   => "+-------+------------------------------+",
	"line_start"  => "| ",
	"line_separator" => " | ",
	"line_end"    => " |",
	"line_length" => 40
}

#methods for manipulating and displaying the list of data
module List

	#prints the entire list
	def self.print
		#read data file
		data = []
		file_length = 0
		File.open($datafile) {|f| file_length = f.read.count("\n")}
		File.open($datafile,"r").each_with_index do |line, index=0|
			if index+1 > file_length - $settings["lines"]
				data.push line.split("|")
			end
		end
		#display data
		puts $settings["first_line"]
		for i in 0..data.length-1
			#grab and reformat data
			time = Time.parse(data[i][0]).strftime("%H:%M")
			task = data[i][1].chomp
			#ready data for display
			line = $settings["line_start"]+time+$settings["line_separator"]+task+$settings["line_separator"]
			until line.length == $settings["line_length"]-$settings["line_end"].length
				line += " "
			end
			line += $settings["line_end"]
			#print data
			puts line
		end
		puts $settings["last_line"]
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
		puts "Usage:
                display all tasks
  <task>:       add a new task with the given text
  -c, --clear   delete all tasks
  -d, --delete  delete the latest task
  -e, --edit    open data file in your default text editor
  -h, --help    display this help information"
	end

end

#command line interface
if ARGV.length == 0
	List.print
else
	case ARGV[0]
	when "-c","--clear"
		puts "list cleared"
		List.clear
	when "-d","--delete"
		List.remove
		List.print
	when "-e","--edit"
		List.edit
	when "-h","--help"
		List.help
	else
		List.add ARGV.join(" ")
		List.print
	end
end
