# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# TODO: how to handle timezone situation?
# https://www.reinteractive.net/posts/168-dealing-with-timezones-effectively-in-rails

possible_cities = ['san francisco', 'chicago', 'new york city'];

user = User.create({ username: 'josh', email: 'lol', password: 'lol' });
user2 = User.create({ username: 'josh2', email: 'lol2', password: 'lol' });

# create appointments in 'created' state
user.appointments.create({
    scheduled_for: Faker::Time.forward(12, :evening),
    city: possible_cities.sample,
    notes: Faker::Hacker.say_something_smart });

# create appointments in 'requested' state
appt = user.appointments.build({
    scheduled_for: Faker::Time.forward(12, :evening),
    city: possible_cities.sample,
    notes: Faker::Hacker.say_something_smart });

appt.request! user

# create appointments in 'offered' state
appt = user.appointments.build({
    scheduled_for: Faker::Time.forward(12, :evening),
    city: possible_cities.sample,
    notes: Faker::Hacker.say_something_smart });

appt.offer! user

# create appointments in 'fulfilled' state
appt = user.appointments.build({
    scheduled_for: Faker::Time.forward(12, :evening),
    city: possible_cities.sample,
    notes: Faker::Hacker.say_something_smart });

appt.request user2
appt.fulfill_request! user

# create appointments in 'completed' state
appt = user.appointments.build({
    scheduled_for: Faker::Time.forward(12, :evening),
    city: possible_cities.sample,
    notes: Faker::Hacker.say_something_smart });

appt.request user2
appt.fulfill_request user
appt.complete!

# create appointments in 'fulfilled' state
appt = user2.appointments.build({
    scheduled_for: Faker::Time.forward(12, :evening),
    city: possible_cities.sample,
    notes: Faker::Hacker.say_something_smart });

appt.request user2
appt.fulfill_request! user

# create appointments in 'fulfilled' state
appt = user2.appointments.build({
    scheduled_for: Faker::Time.forward(12, :evening),
    city: possible_cities.sample,
    notes: Faker::Hacker.say_something_smart });

appt.offer user2
appt.fulfill_offer! user