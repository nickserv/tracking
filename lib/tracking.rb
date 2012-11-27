# Require all of tracking's stuff
lib_path = File.join(File.dirname(__FILE__), 'tracking', '*.rb')
Dir[lib_path].each { |file| require file }

# Tracking is the main namespace that all of the other modules and classes are a
# part of
module Tracking
end
