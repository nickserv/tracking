#Tracking's core.

#imports
require "yaml"
require "time"
require "csv"

#model/controller module methods
module Tracking
	module List

		extend self

		$config = YAML.load_file(ENV["HOME"] + "/.tracking/config.yml")
		$config[:data_file] = File.expand_path($config[:data_file])
		$data_file = CSV.open($config[:data_file], "r+", {:col_sep => "\t"})

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
			#lines = File.readlines($config[:data_file])
			lines.pop #or delete specific lines in the future
			#File.open($config[:data_file], "w") do |f| 
			$data_file.write do |f| 
				lines.each do |line|
					f.puts line
				end
			end
		end

		#clears the entire list
		def clear
			FileUtils.rm $config[:data_file]
			FileUtils.touch $config[:data_file]
		end

		#opens the list data file in a text editor
		def edit
			system ENV["EDITOR"] + " " + $config[:data_file]
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
			case $config[:elapsed_format]
			when :colons
				if $config[:show_elapsed_seconds]
					return "%02d:%02d:%02d:%02d" % [days, hours, minutes, seconds]
				else
					return "%02d:%02d:%02d" % [days, hours, minutes]
				end
			when :letters
				if $config[:show_elapsed_seconds]
					return "%02dd %02dh %02dm %02ds" % [days, hours, minutes, seconds]
				else
					return "%02dd %02dh %02dm" % [days, hours, minutes]
				end
			end
		end

	end
end
