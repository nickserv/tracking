$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'
require 'fileutils'

class TestCLI < Test::Unit::TestCase
	context 'Tracking\'s CLI' do

		def setup
			FileUtils.cd File.expand_path('~/.tracking')
			FileUtils.mkdir 'test_backup'
			%w(config.yml data.csv).each do |f|
				FileUtils.mv(f, 'test_backup') if File.exist? f
			end
		end

		def teardown
			FileUtils.cd File.expand_path('~/.tracking/test_backup')
			%w(config.yml data.csv).each do |f|
				FileUtils.mv(f, File.expand_path('..')) if File.exist? f
			end
			FileUtils.cd File.expand_path('..')
			FileUtils.rmdir 'test_backup'
		end

		should 'perform a few operations on a new list and then clear it' do
			#test_command '-c'
			capture_output { Tracking::List.clear }
			#test_command
			capture_output { Tracking::CLI.display }
			#test_command 'first task'
			capture_output { Tracking::List.add 'first task' }
			#test_command 'second task'
			capture_output { Tracking::List.add 'second task' }
			#test_command
			capture_output { Tracking::CLI.display }
			#test_command '-d'
			capture_output { Tracking::List.delete }
			#test_command '-c'
			capture_output { Tracking::List.clear }
		end

		should 'display help information (run from the system\'s shell)' do
			test_command '-h'
		end

	end
end
