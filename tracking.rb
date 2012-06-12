#!/usr/bin/env ruby

#imports
require "time"

#data file
$settings = {
	:datafile    => ENV["HOME"]+"/.tracking",
	:lines       => 10,
	:first_line  => "+-------+--------------------------------------+",
	:last_line   => "+-------+--------------------------------------+"
}

#model/controller module methods
module Tracking

	#adds an item to the list
	def self.add item
		File.open($settings[:datafile],"a") do |f|
			newline = "\n"
			if File.zero?($settings[:datafile])
				newline = ""
			end
			date = Time.now.to_s
			f.write(newline+date+"|"+item.chomp)
		end
	end

	#removes an item from the list
	def self.remove
		lines = File.readlines($settings[:datafile])
		lines.pop
		File.open($settings[:datafile], "w") do |f| 
			lines.each do |line|
				if line == lines.last
					line.chomp!
				end
				f.print(line)
			end
		end
	end

	#clears the entire list
	def self.clear
		File.open($settings[:datafile],"w") do |f|
			f.write ""
		end
	end

	#opens the list data file in a text editor
	def self.edit
		system ENV["EDITOR"] + " " + $settings[:datafile]
	end

end

#gets and formats the amount of time passed between two times
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
