require 'spec_helper'

describe Tracking::CLI do

	before :each { backup_data }
	after  :each { restore_data }

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

end
