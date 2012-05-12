#!/usr/bin/env ruby

$filename = "data.txt"

module List

	def self.print
		puts "tracking display (run \"tracking help\" for help)"
		File.open($filename,"r").each do |l|
			puts l
		end
	end

	def self.add item
		File.open($filename,"a") do |f|
			date = "DATE"
			f.write("\n"+date+" "+item)
		end
	end

	def self.clear
		File.open($filename,"w") do |f|
			f.write ""
		end
	end

	def self.edit
		system ENV["EDITOR"] + " " + $filename
	end

end

if ARGV.length == 0
	List.print
else
	if ARGV[0] == "clear"
		puts "list cleared"
		List.clear
	elsif ARGV[0] == "edit"
		List.edit
	else
		List.add ARGV[0]
		List.print
	end
end
