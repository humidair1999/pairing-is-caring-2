# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create({ username: 'josh', email: 'lol', password: 'lol' });

# TODO: how to handle timezone situation?
# https://www.reinteractive.net/posts/168-dealing-with-timezones-effectively-in-rails
user.appointments.create({
    scheduled_for: DateTime.new(2013, 12, 24, 8, 21, 0),
    city: 'San Francisco',
    notes: 'some weird fake notes about some dumb shit' });

user.appointments.create({
    scheduled_for: DateTime.new(2013, 12, 25, 8, 21, 0),
    city: 'Chicago',
    notes: 'some weird fake notes about some dumb shit' });

user.appointments.create({
    scheduled_for: DateTime.new(2013, 12, 26, 8, 21, 0),
    city: 'San Francisco',
    notes: 'some weird fake notes about some dumb shit' });

appt = user.appointments.build({
    scheduled_for: DateTime.new(2013, 12, 27, 8, 21, 0),
    city: 'New York City',
    notes: 'some weird fake notes about some dumb shit' });

appt.fulfill! 'student obj'

appt = user.appointments.build({
    scheduled_for: DateTime.new(2013, 12, 28, 8, 21, 0),
    city: 'Chicago',
    notes: 'some weird fake notes about some dumb shit' });

appt.fulfill! 'student obj2'

user.appointments.create({
    scheduled_for: DateTime.new(2013, 12, 29, 8, 21, 0),
    city: 'San Francisco',
    notes: 'some weird fake notes about some dumb shit' });

appt = user.appointments.build({
    scheduled_for: DateTime.new(2013, 12, 30, 8, 21, 0),
    city: 'New York City',
    notes: 'some weird fake notes about some dumb shit' });

appt.fulfill 'student obj3'
appt.complete!

user.appointments.create({
    scheduled_for: DateTime.new(2013, 12, 30, 8, 21, 0),
    city: 'New York City',
    notes: 'some weird fake notes about some dumb shit' });

user.appointments.create({
    scheduled_for: DateTime.new(2013, 12, 30, 8, 21, 0),
    city: 'New York City',
    notes: 'some weird fake notes about some dumb shit' });

user.appointments.create({
    scheduled_for: DateTime.new(2013, 12, 30, 8, 21, 0),
    city: 'New York City',
    notes: 'some weird fake notes about some dumb shit' });

user2 = User.create({ username: 'samantha', email: 'lol2', password: 'lol' });

user2.appointments.create({
    scheduled_for: DateTime.new(2013, 12, 30, 8, 21, 0),
    city: 'New York City',
    notes: 'some weird fake notes about some dumb shit' });

user2.appointments.create({
    scheduled_for: DateTime.new(2013, 12, 30, 8, 21, 0),
    city: 'New York City',
    notes: 'some weird fake notes about some dumb shit' });

user2.appointments.create({
    scheduled_for: DateTime.new(2013, 12, 30, 8, 21, 0),
    city: 'New York City',
    notes: 'some weird fake notes about some dumb shit' });