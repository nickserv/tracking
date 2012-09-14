require 'spec_helper'

describe Tracking::CLI do

	before(:all) { backup_data }
	after(:all)  { restore_data }

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
