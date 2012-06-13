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
	#calculate the elapsed time and break it down into different units
	seconds = (time2 - time1).floor
	if seconds >= 60
		minutes = seconds / 60
		seconds = seconds % 60
		if minutes >= 60
			hours = minutes / 60
			minutes = minutes % 60
			if hours >= 24
				days = hours / 24
				hours = hours % 24
			end
		end
	end
	#return a string of the formatted elapsed time
	elapsed = ""
	if days
		elapsed += "#{days.to_s}d "
	end
	if hours
		elapsed += "#{hours.to_s}h "
	end
	if minutes
		elapsed += "#{minutes.to_s}m "
	end
	if seconds
		elapsed += "#{seconds.to_s}s"
	end
	return elapsed
end
