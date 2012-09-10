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
		capture_output do
			Tracking::List.clear
			Tracking::CLI.display
			Tracking::List.add 'first task'
			Tracking::List.add 'second task'
			Tracking::List.rename 'second task, renamed'
			Tracking::CLI.display
			Tracking::List.delete
			Tracking::List.clear
		end
	end

=begin
	it 'performs a few operations on a new list and then clears it' do
		test_command '-c'
		test_command
		test_command 'first task'
		test_command 'second task'
		test_command '-r second task, renamed'
		test_command
		test_command '-d'
		test_command '-c'
	end
=end

	it 'displays help information (run from the system shell)' do
		test_command '-h'
	end

end
