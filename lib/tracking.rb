# Require file utilities
require 'fileutils'

# Require Tracking::Config
require File.join(File.dirname(__FILE__), 'tracking', 'config')

# Create ~/.tracking
unless File.exist? File.join(ENV['HOME'], '.tracking')
	Dir.mkdir File.join(ENV['HOME'], '.tracking')
end

# Require the rest of tracking
require File.join(File.dirname(__FILE__), 'tracking', 'list')
require File.join(File.dirname(__FILE__), 'tracking', 'cli')

# Tracking is the main namespace that all of the other modules and classes are a part of
module Tracking
end
