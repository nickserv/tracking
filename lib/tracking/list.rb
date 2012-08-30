require 'fileutils'
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

		# Reads part of the data file and converts the data into Task objects
		#
		# @param [Integer] max the maximum number of items to get from the end of
		# the data file
		#
		# @return [Array] an array of Task objects
		def get max=Config[:lines]
			if File.exist? @data_file
				all_lines = CSV.read(@data_file, @csv_options)
				lines = all_lines[-max..-1]
				lines = all_lines if lines.nil?

				tasks = []
				lines.each_with_index do |line, i|
					name = line[1]
					start_time = Time.parse line[0]
					end_time = i<lines.length-1 ? Time.parse(lines[i+1][0]) : Time.now
					tasks << Task.new(name, start_time, end_time)
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

	end
end
