# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# TODO: how to handle timezone situation?
# https://www.reinteractive.net/posts/168-dealing-with-timezones-effectively-in-rails
Appointment.create({ scheduled_for: DateTime.new(2013, 12, 24, 8, 21, 0), city: 'San Francisco' });
Appointment.create({ scheduled_for: DateTime.new(2013, 12, 25, 8, 21, 0), city: 'Chicago' });
Appointment.create({ scheduled_for: DateTime.new(2013, 12, 26, 8, 21, 0), city: 'San Francisco' });
Appointment.create({ scheduled_for: DateTime.new(2013, 12, 24, 8, 21, 0), city: 'New York City' });