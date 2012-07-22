#Tracking's core.

#imports
require "yaml"
require "time"
require "csv"

#model/controller module methods
module Tracking
	module List

		extend self

		Config = YAML.load_file(ENV["HOME"] + "/.tracking/config.yml")
		Config[:data_file] = File.expand_path(Config[:data_file])
		$data_file = CSV.open(Config[:data_file], "r+", {:col_sep => "\t"})

		#adds an item to the list
		def add item
			date = Time.now.to_s
			CSV.open($data_file.path, "a", {:col_sep => "\t"}) do |csv|
				csv << [ date, item ]
			end
		end

		#deletes an item from the list
		def delete
			lines = $data_file.readlines
			#lines = File.readlines(Config[:data_file])
			lines.pop #or delete specific lines in the future
			#File.open(Config[:data_file], "w") do |f| 
			CSV.open($data_file.path, "w", {:col_sep => "\t"}) do |f| 
				lines.each do |line|
					f.puts line
				end
			end
		end

		#clears the entire list
		def clear
			FileUtils.rm Config[:data_file]
			FileUtils.touch Config[:data_file]
		end

		#opens the list data file in a text editor
		def edit
			system ENV["EDITOR"] + " " + Config[:data_file]
		end


		#gets and formats the amount of time passed between two times
		def get_elapsed_time(time1, time2)
			#calculate the elapsed time and break it down into different units
			seconds = (time2 - time1).floor
			minutes = hours = days = 0
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
			case Config[:elapsed_format]
			when :colons
				if Config[:show_elapsed_seconds]
					return "%02d:%02d:%02d:%02d" % [days, hours, minutes, seconds]
				else
					return "%02d:%02d:%02d" % [days, hours, minutes]
				end
			when :letters
				if Config[:show_elapsed_seconds]
					return "%02dd %02dh %02dm %02ds" % [days, hours, minutes, seconds]
				else
					return "%02dd %02dh %02dm" % [days, hours, minutes]
				end
			end
		end

	end
end
