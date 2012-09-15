# Require all of tracking's stuff
lib_path = File.join(File.dirname(__FILE__), 'tracking')
require File.join(lib_path, 'config')
require File.join(lib_path, 'list')
require File.join(lib_path, 'task')
require File.join(lib_path, 'cli')

# Tracking is the main namespace that all of the other modules and classes are a
# part of
module Tracking
end
