require 'spec_helper'

describe Tracking::Task do

	it 'creates a new Task from the past and gets data from it' do
		start_time = Time.new(1993,6,30, 12) #June 30, 1993, at 12:00 PM
		end_time = Time.new(1993,6,30, 13) #June 30, 1993, at 1:00 PM
		past_task = Tracking::Task.new('test task', start_time, end_time)
		# Test raw data
		past_task.raw(:name).should == 'test task'
		past_task.raw(:start_time).class.should == Time
		past_task.raw(:end_time).class.should == Time
		# Test instance methods
		past_task.name.should == 'test task'
		past_task.start_time.should == past_task.raw(:start_time).strftime('%H:%M')
		past_task.to_s.should == "name: test task; start: #{past_task.raw(:start_time)}; end: #{past_task.raw(:end_time)};"
		past_task.current?.should be_false
		past_task.elapsed_time(:colons,false).should == '00:01:00'
	end

end
