require 'spec_helper'

describe Tracking::List do

	before(:all) { backup_data }
	after(:all)  { restore_data }

	it 'performs a few operations on a new list and then clears it' do
		capture_output do
			Tracking::List.clear
			Tracking::List.get.length.should == 0
			Tracking::List.add 'first task'
			Tracking::List.add 'second task'
			Tracking::List.get.length.should == 2
			Tracking::List.get(:query => 'task').length.should == 2
			Tracking::List.get(:max => :all).length.should == 2
			Tracking::List.get(:max => 1).length.should == 1
			Tracking::List.rename 'second task, renamed'
			Tracking::List.delete
			Tracking::List.get.length.should == 1
			Tracking::List.clear
			Tracking::List.get.length.should == 0
		end
	end

end
