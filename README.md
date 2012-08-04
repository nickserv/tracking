#tracking [![Build Status](https://secure.travis-ci.org/thenickperson/tracking.png?branch=master)](http://travis-ci.org/thenickperson/tracking) [![Dependency Status](https://gemnasium.com/thenickperson/tracking.png)](https://gemnasium.com/thenickperson/tracking)
A simple and configurable command line time tracker.

##Installation

`gem install tracking`

If you're on Windows, you should set up [Ruby Installer](http://rubyinstaller.org/downloads/) and [DevKit](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit) first.

Also, tracking does not work on Ruby 1.8 (yet). Please upgrade to Ruby 1.9.3.

##Features
- concise and configurable display
- simple syntax
- portable data

##Ideas (future)
- hashtag-like tags for organizing tasks
- different ways to view your data

##Tutorial
```
$ tracking essay for English class
+-------+------------------------------------------+----------+
| start |                   task                   | elapsed  |
+-------+------------------------------------------+----------+
| 12:00 | essay for English class                  | 00:00:00 |
+-------+------------------------------------------+----------+
$ tracking getting distracted on Reddit
+-------+------------------------------------------+----------+
| start |                   task                   | elapsed  |
+-------+------------------------------------------+----------+
| 12:00 | essay for English class                  | 00:00:20 |
| 12:20 | getting distracted on Reddit             | 00:00:00 |
+-------+------------------------------------------+----------+
$ tracking
+-------+------------------------------------------+----------+
| start |                   task                   | elapsed  |
+-------+------------------------------------------+----------+
| 12:00 | essay for English class                  | 00:00:20 |
| 12:20 | getting distracted on Reddit             | 00:00:05 |
+-------+------------------------------------------+----------+
$ tracking back to work
+-------+------------------------------------------+----------+
| start |                   task                   | elapsed  |
+-------+------------------------------------------+----------+
| 12:00 | essay for English class                  | 00:00:20 |
| 12:20 | getting distracted on Reddit             | 00:00:10 |
| 12:30 | back to work                             | 00:00:00 |
+-------+------------------------------------------+----------+
```

##Usage
```
Usage: tracking [mode]
                                     display all tasks
    <task>                           start a new task with the given text
    -c, --clear                      delete all tasks
    -d, --delete                     delete the last task
    -h, --help                       displays this help information
```

##Configuration
The config file for tracking is located in `~/.tracking/config.yml`.

The default settings are listed below, along with a description of each setting.
```ruby
# path to the data file (string, ~ can be used)
:data_file: ~/.tracking/data.csv
# number of lines to be displayed at once by default (integer)
:lines: 10
# width of the task name column, in characters (integer)
:task_width: 40
# format to use for elapsed time display (:colons or :letters)
:elapsed_format: :colons
# toggle header describing tracking's display columns (true or false)
:show_header: true
# toggle display of seconds in elapsed time (true of false)
:show_elapsed_seconds: false
```

##Elapsed Time Formats
Elapsed times are displayed in this order: days, hours, minutes, seconds (if enabled)
- hide elapsed seconds
	- colons: `01:02:03` (default)
	- letters: `01d 02h 03m`
- show elapsed seconds
	- colons: `01:02:03:04`
	- letters: `01d 02h 03m 04s`

##Contributing to tracking
- Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
- Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
- Fork the project.
- Start a feature/bugfix branch.
- Commit and push until you are happy with your contribution.
- Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
- Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

##Similar Projects
- [timetrap](https://github.com/samg/timetrap)
- [d-time-tracker](https://github.com/DanielVF/d-time-tracker)
- [to-do](http://github.com/kristenmills/to-do) if you want a good command command line todo manager to complement tracking

##Special Thanks
- [to-do](http://github.com/kristenmills/to-do) and [timetrap](https://github.com/samg/timetrap) for letting me borrow some code

##Copyright
Copyright (c) 2012 Nicolas McCurdy. See LICENSE.txt for
further details.
