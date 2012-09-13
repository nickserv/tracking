require 'spec_helper'

describe Tracking::Task do

	def test_task current=false
		# Create task for testing
		if current
			start_time = Time.now()
			end_time = nil
		else
			start_time = Time.new(1993,6,30, 12) # June 30, 1993, at 12:00 PM
			end_time = Time.new(1993,6,30, 13)   # June 30, 1993, at 1:00 PM
		end
		task = Tracking::Task.new('test task', start_time, end_time)
		# Test raw data
		task.raw(:name).should == 'test task'
		task.raw(:start_time).class.should == Time
		if current
			task.raw(:end_time).nil?.should be_true
		else
			task.raw(:end_time).class.should == Time
		end
		# Test instance methods
		task.name.should == 'test task'
		task.start_time.should == task.raw(:start_time).strftime('%H:%M')
		task.to_s.should == "name: test task; start: #{task.raw(:start_time)}; end: #{task.raw(:end_time)};"
		task.current?.should == current
		task.elapsed_time(:colons,false).should == '00:01:00' if not current
	end

	it 'creates a Task set in the past and gets data from it' do
		test_task
	end

	it 'creates a new (current) Task and gets data from it' do
		test_task true
	end

end
