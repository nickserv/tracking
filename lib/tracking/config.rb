#utilities for tracking's config file

#imports
require 'yaml'

#config module methods
module Tracking
	# similar to Sam Goldstein's config.rb for timetrap
	# @see https://github.com/samg/timetrap/
	module Config

		extend self

		PATH = File.join(ENV['HOME'], '.tracking', 'config.yml')
		
		#default values
		def defaults
			{
				# path to the data file (string, ~ can be used)
				:data_file => '~/.tracking/data.csv',
				# number of lines to be displayed at once by default (integer)
				:lines => 10,
				# width of the task name column, in characters (integer)
				:task_width => 40,
				# format to use for elapsed time display (:colons or :letters)
				:elapsed_format => :colons,
				# toggle header describing tracking's display columns (true or false)
				:show_header => true,
				# toggle display of seconds in elapsed time (true of false)
				:show_elapsed_seconds => false
			}
		end

		#accessor for values in the config
		def [] key
			data = YAML.load_file PATH
			defaults.merge(data)[key]
		end

		#setter for keys in config
		def []= key, value
			data = YAML.load_file PATH
			configs = defaults.merge(data)
			configs[key] = value
			File.open(PATH, 'w') do |fh|
				fh.puts(configs.to_yaml)
			end
		end

		#writes the config file path
		def write
			configs = if File.exist? PATH
				defaults.merge(YAML.load_file PATH)
			else 
				defaults
			end
			File.open(PATH, 'w') do |fh|
				fh.puts configs.to_yaml
			end
		end

	end
end
