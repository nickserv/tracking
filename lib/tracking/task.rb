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

		# Accessor for this tasks's name (read/write)
		attr_accessor :name

		# Formats and returns the start time of this task.
		#
		# @return [String] the formatted start time of this task
		def start_time
			return @start_time.strftime('%H:%M')
		end

		# Calculates, formats, and returns the elapsed time of this task. Currently
		# just a wrapper for List.get_elapsed_time, using the Task's own data.
		#
		# @return [String] the formatted elapsed time of this task
		def elapsed_time
			return List.get_elapsed_time(@start_time, @end_time)
		end

	end
end
