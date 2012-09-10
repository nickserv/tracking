require 'helper'
require 'fileutils'

describe Tracking::CLI do

	before :each do
		FileUtils.cd File.expand_path('~/.tracking')
		FileUtils.mkdir 'test_backup'
		%w(config.yml data.csv).each do |f|
			FileUtils.mv(f, 'test_backup') if File.exist? f
		end
	end

	after :each do
		FileUtils.cd File.expand_path('~/.tracking/test_backup')
		%w(config.yml data.csv).each do |f|
			FileUtils.mv(f, File.expand_path('..')) if File.exist? f
		end
		FileUtils.cd File.expand_path('..')
		FileUtils.rmdir 'test_backup'
	end

	it 'performs a few operations on a new list and then clears it' do
		#test_command '-c'
		capture_output { Tracking::List.clear }
		#test_command
		capture_output { Tracking::CLI.display }
		#test_command 'first task'
		capture_output { Tracking::List.add 'first task' }
		#test_command 'second task'
		capture_output { Tracking::List.add 'second task' }
		#test_command '-r second task, renamed'
		capture_output { Tracking::List.rename 'second task, renamed' }
		#test_command
		capture_output { Tracking::CLI.display }
		#test_command '-d'
		capture_output { Tracking::List.delete }
		#test_command '-c'
		capture_output { Tracking::List.clear }
	end

	it 'displays help information (run from the system shell)' do
		test_command '-h'
	end

end
