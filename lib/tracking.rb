require File.join(File.dirname(__FILE__), "tracking", "tracking")
if !File.exists?(File.join(ENV["HOME"], ".tracking"))
	Dir.mkdir(File.join(ENV["HOME"], ".tracking"))
	#create config and data files
end
require File.join(File.dirname(__FILE__), "tracking", "command_line")
