require 'spec_helper'
require 'fileutils'

describe Tracking::CLI do

	before :each do
		backup_data
	end

	after :each do
		restore_data
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

end
