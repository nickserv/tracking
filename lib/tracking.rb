require 'fileutils'

require File.join(File.dirname(__FILE__), 'tracking', 'config')

#create ~/.tracking
if not File.exist? File.join(ENV['HOME'], '.tracking')
	Dir.mkdir File.join(ENV['HOME'], '.tracking')
end

#create config file
if not File.exist? File.join(ENV['HOME'], '.tracking', 'config.yml')
	Tracking::Config.write
end

#create data file
if not File.exist? File.expand_path Tracking::Config[:data_file]
	FileUtils.touch File.expand_path Tracking::Config[:data_file]
end

require File.join(File.dirname(__FILE__), 'tracking', 'list')
require File.join(File.dirname(__FILE__), 'tracking', 'cli')
