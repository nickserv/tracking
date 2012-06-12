#!/usr/bin/env ruby

#imports
require_relative "tracking.rb"

#command line interface
if ARGV.length == 0
	List.display
else
	case ARGV[0]
	when "-c","--clear"
		puts "list cleared"
		List.clear
	when "-d","--delete"
		List.remove
		List.display
	when "-e","--edit"
		List.edit
	when "-h","--help"
		List.help
	else
		List.add ARGV.join(" ")
		List.display
	end
end
