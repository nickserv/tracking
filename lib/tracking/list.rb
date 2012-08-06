require 'yaml'
require 'time'
require 'csv'

module Tracking
	# Tracking's core. Contains methods for manipulating tasks in the data file
	# and preparing its data for a user interface.
	module List
		extend self

		# The path to tracking's data file
		@data_file = File.expand_path(Config[:data_file])

		# The options tracking uses for Ruby's CSV interface
		@csv_options = { :col_sep => "\t" }

		# Read the end of the data file and convert it into tasks (for display).
		# Note that this currently only works if the requested tasks are contiguous,
		# ending with the last task in the data file.
		#
		# @return [Array] an array of arrays of strings
		def get
			if File.exist? @data_file
				all_lines = CSV.read(@data_file, @csv_options)
				lines = all_lines.length > Config[:lines] ? all_lines[-Config[:lines]..-1] : all_lines

				tasks = []
				lines.each_with_index do |line, i|
					name = line[1]
					start_time = Time.parse line[0]
					end_time = i<lines.length-1 ? Time.parse(lines[i+1][0]) : Time.now
					tasks << [
						start_time.strftime('%H:%M'), # Start Time
						name, # Name
						get_elapsed_time(start_time, end_time) # Elapsed time
					]
				end
				return tasks
			else
				return []
			end
		end

		# Adds a task to the list
		#
		# @param [String] task the name of the task to add to the list
		def add task
			time = Time.now.to_s
			FileUtils.touch @data_file unless File.exist? @data_file
			File.open(@data_file, 'a') do |file|
				file << [ time, task ].to_csv(@csv_options)
			end
		end

		# Deletes the last task from the list
		def delete
			if File.exist? @data_file
				lines = File.readlines @data_file
				lines.pop # Or delete specific lines in the future
				File.open(@data_file, 'w') do |file| 
					lines.each do |line|
						file << line
					end
				end
			end
		end

		# Clears the entire list
		def clear
			if File.exist? @data_file
				FileUtils.rm @data_file
				FileUtils.touch @data_file
			end
		end

		# Gets the elapsed time between two times and formats it into a string for
		# display (depending on the user's display settings for elapsed times)
		#
		# @param [Time] time1 the start time of a task
		# @param [Time] time2 the end time of a task
		# @return [String] a formatted string of the elapsed time between time1 and
		# time2
		def get_elapsed_time(time1, time2)
			# Calculate the elapsed time and break it down into different units
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
			# Return a string of the formatted elapsed time
			case Config[:elapsed_format]
			when :colons
				if Config[:show_elapsed_seconds]
					return '%02d:%02d:%02d:%02d' % [days, hours, minutes, seconds]
				else
					return '%02d:%02d:%02d' % [days, hours, minutes]
				end
			when :letters
				if Config[:show_elapsed_seconds]
					return '%02dd %02dh %02dm %02ds' % [days, hours, minutes, seconds]
				else
					return '%02dd %02dh %02dm' % [days, hours, minutes]
				end
			end
		end

	end
end
