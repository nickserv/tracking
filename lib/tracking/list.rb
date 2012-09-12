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

		# Reads part of the data file and creates Task objects from that data
		#
		# @param [Integer] max the maximum number of items to get from the end of
		# the data file (Note: when max is set to 0, all tasks are retrieved)
		#
		# @return [Array] an array of Task objects
		def get max=Config[:lines]
			if File.exist? @data_file
				all_lines = CSV.read(@data_file, @csv_options)
				lines = all_lines[-max..-1]
				lines = all_lines if lines.nil?

				tasks = []
				lines.each_with_index do |line, i|
					tasks << create_task_from_data(line, lines[i+1])
				end
				return tasks
			else
				return []
			end
		end

		# Generates a Task object from one or two lines of semi-parsed CSV data
		#
		# @param [Array] line the line of semi-parsed CSV data to use
		# @param [Array] next_line the next line of data, if it exists
		#
		# @return [Task] the generated Task object
		def create_task_from_data(line, next_line=nil)
			name = line[1]
			start_time = Time.parse line[0]
			end_time = next_line.nil? ? nil : Time.parse(next_line[0])

			return Task.new(name, start_time, end_time)
		end

		# Adds a task to the list
		#
		# @param [String] name the name of the task to add to the list
		def add name, time=Time.now
			FileUtils.touch @data_file unless File.exist? @data_file
			File.open(@data_file, 'a') do |file|
				file << [ time.to_s, name ].to_csv(@csv_options)
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

		# Renames the last task in the list
		#
		# @param [String] name the new name for the last task
		def rename name
			# get task data
			old_task = get(1).first
			# delete last task
			delete
			# add new task with old time
			add(name, old_task.raw(:start_time))
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
