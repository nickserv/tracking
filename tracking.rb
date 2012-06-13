#!/usr/bin/env ruby
#Tracking's core.

#imports
require_relative "config"
require "time"

#model/controller module methods
module Tracking

	#adds an item to the list
	def self.add item
		File.open($config[:data_file],"a") do |f|
			newline = "\n"
			if File.zero?($config[:data_file])
				newline = ""
			end
			date = Time.now.to_s
			f.write(newline+date+"|"+item.chomp)
		end
	end

	#removes an item from the list
	def self.remove
		lines = File.readlines($config[:data_file])
		lines.pop
		File.open($config[:data_file],"w") do |f| 
			lines.each do |line|
				if line == lines.last
					line.chomp!
				end
				f.print line
			end
		end
	end

	#clears the entire list
	def self.clear
		File.open($config[:data_file],"w") do |f|
			f.write ""
		end
	end

	#opens the list data file in a text editor
	def self.edit
		system ENV["EDITOR"] + " " + $config[:data_file]
	end

end

#gets and formats the amount of time passed between two times
def get_elapsed_time(time1, time2)
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
	elapsed = ""
	if d
		elapsed += "#{d.to_s}d "
	end
	if h
		elapsed += "#{h.to_s}h "
	end
	if m
		elapsed += "#{m.to_s}m "
	end
	if s
		elapsed += "#{s.to_s}s"
	end
	return elapsed
end
