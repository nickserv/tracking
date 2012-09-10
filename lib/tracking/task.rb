module Tracking
	# The class for all Task objects created by List and passed to interfaces.
	# Holds all relevant data for Tasks, as well as methods for computing new Task
	# data as needed. Tasks internally save data (in their appropriate types) to
	# intance variables, while public accessors return data in strings for
	# display.
	class Task

		# Creates a new Task object. Data passed into its arguments is kept
		# (unchanged) in instance variables.
		#
		# @param [String] name the tasks's name
		# @param [Time] start_time the tasks's start time
		# @param [Time] end_time the tasks's end time
		def initialize(name, start_time, end_time)
			@name = name
			@start_time = start_time
			@end_time = end_time
		end

		# Gets raw data from the task object, without doing any conversions or
		# formatting
		#
		# @param [Symbol] key the key of the desired value
		#
		# @return the value of the requested key
		def raw key
			case key
			when :name
				return @name
			when :start_time
				return @start_time
			when :end_time
				return @end_time
			end
		end

		# Converts the task object into a string (for debugging)
		def to_s
			return "name: #{name}; start: #{@start_time}; end: #{@end_time};"
		end

		# Calculates the length of strings from Task#elapsed_time (using the current
		# elapsed time format).
		#
		# @return [String] the length of strings from Task#elapsed_time
		def self.elapsed_time_length
			test_task = Task.new('test', Time.now, Time.now)
			return test_task.elapsed_time.length
		end

		# Accessor for this tasks's name (read/write)
		attr_accessor :name

		# Formats and returns the start time of this task.
		#
		# @return [String] the formatted start time of this task
		def start_time
			return @start_time.strftime('%H:%M')
		end

		# Calculates, formats, and returns the elapsed time of this task.
		#
		# @return [String] the formatted elapsed time of this task
		def elapsed_time
			# Calculate the elapsed time and break it down into different units
			seconds = (@end_time - @start_time).floor
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
				elapsed = '%02d:%02d:%02d' % [days, hours, minutes]
				elapsed += ':%02d' % seconds if Config[:show_elapsed_seconds]
			when :letters
				elapsed = '%02dd %02dh %02dm' % [days, hours, minutes]
				elapsed += ' %02ds' % seconds if Config[:show_elapsed_seconds]
			end
			return elapsed
		end

	end
end
