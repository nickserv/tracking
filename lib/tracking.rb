require File.join(File.dirname(__FILE__), "tracking", "list")
if !File.exists?(File.join(ENV["HOME"], ".tracking"))
	Dir.mkdir(File.join(ENV["HOME"], ".tracking"))
	#create config and data files
end
require File.join(File.dirname(__FILE__), "tracking", "cli")
