#Utilities for Tracking's config file.

#imports
require "yaml"

#config module methods
module Tracking
	module Config

		extend self

		PATH = File.join(ENV['HOME'], '.tracking', 'config.yml')
		
		#default values
		def defaults
			{
				# path to the data file
				:data_file => "~/.tracking/data.txt",
				# number of lines to be displayed at once by default
				:lines => 10
			}
		end

		#accessor for values in the config
		def [] key
			fileval = YAML.load_file PATH
			defaults.merge(fileval)[key]
		end

		#setter for keys in config
		def []= key, value
			fileval = YAML.load_file PATH
			configs = defaults.merge(fileval)
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
				fh.puts(configs.to_yaml)
			end
		end

	end
end
