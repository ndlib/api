require 'icalendar'

cal_file = File.open("./calendar_data/Fall_2013_.ics")
cals = Icalendar.parse(cal_file)
puts cals.inspect

