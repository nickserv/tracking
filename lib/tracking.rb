require "fileutils"

require File.join(File.dirname(__FILE__), "tracking", "config")
if not File.exists? File.join(ENV["HOME"], ".tracking")
	Dir.mkdir File.join(ENV["HOME"], ".tracking")
	Tracking::Config.write
	FileUtils.touch File.expand_path Tracking::Config[:data_file]
end

require File.join(File.dirname(__FILE__), "tracking", "list")
require File.join(File.dirname(__FILE__), "tracking", "cli")

Tracking::CLI.parse
