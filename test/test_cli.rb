$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

class TestCLI < Test::Unit::TestCase
	context "Tracking's CLI" do

		should "clear list (to prepare for other tests)" do
			capture_output { Tracking::List.clear }
		end

		should "display empty list" do
			capture_output { Tracking::CLI.display }
		end

		should "add a task" do
			capture_output { Tracking::List.add "first task" }
		end

		should "add another task" do
			capture_output { Tracking::List.add "second task" }
		end

		should "display list with two items" do
			capture_output { Tracking::CLI.display }
		end

		should "delete the second task" do
			capture_output { Tracking::List.delete }
		end

		should "clear list" do
			capture_output { Tracking::List.clear }
		end

		should "display help information (run from the system's shell)" do
			capture_output { `#{ File.join(File.dirname(__FILE__), "..", "bin", "tracking") } --help` }
		end

	end
end
