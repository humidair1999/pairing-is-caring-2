# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# TODO: how to handle timezone situation?
# https://www.reinteractive.net/posts/168-dealing-with-timezones-effectively-in-rails

possible_cities = ['San Francisco', 'Chicago', 'New York City'];

user = User.create({ username: 'josh', email: 'lol', password: 'lol' });

3.times do
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

    appt.request! 'some student'

    # create appointments in 'offered' state
    appt = user.appointments.build({
        scheduled_for: Faker::Time.forward(12, :evening),
        city: possible_cities.sample,
        notes: Faker::Hacker.say_something_smart });

    appt.offer! 'some mentor'

    # create appointments in 'fulfilled' state
    appt = user.appointments.build({
        scheduled_for: Faker::Time.forward(12, :evening),
        city: possible_cities.sample,
        notes: Faker::Hacker.say_something_smart });

    appt.fulfill!({ student: 'some student', mentor: 'some mentor' });

    # create appointments in 'completed' state
    appt = user.appointments.build({
        scheduled_for: Faker::Time.forward(12, :evening),
        city: possible_cities.sample,
        notes: Faker::Hacker.say_something_smart });

    appt.fulfill({ student: 'some student', mentor: 'some mentor' });
    appt.complete!
end

3.times do
    fake_user = User.create({
        username: Faker::Internet.user_name,
        email: Faker::Internet.email,
        password: Faker::Internet.password });

    # create appointments in 'created' state
    fake_user.appointments.create({
        scheduled_for: Faker::Time.forward(12, :evening),
        city: possible_cities.sample,
        notes: Faker::Hacker.say_something_smart });

    # create appointments in 'requested' state
    appt = fake_user.appointments.build({
        scheduled_for: Faker::Time.forward(12, :evening),
        city: possible_cities.sample,
        notes: Faker::Hacker.say_something_smart });

    appt.request! 'some student'

    # create appointments in 'offered' state
    appt = fake_user.appointments.build({
        scheduled_for: Faker::Time.forward(12, :evening),
        city: possible_cities.sample,
        notes: Faker::Hacker.say_something_smart });

    appt.offer! 'some mentor'

    # create appointments in 'fulfilled' state
    appt = fake_user.appointments.build({
        scheduled_for: Faker::Time.forward(12, :evening),
        city: possible_cities.sample,
        notes: Faker::Hacker.say_something_smart });

    appt.fulfill!({ student: 'some student', mentor: 'some mentor' });

    # create appointments in 'completed' state
    appt = fake_user.appointments.build({
        scheduled_for: Faker::Time.forward(12, :evening),
        city: possible_cities.sample,
        notes: Faker::Hacker.say_something_smart });

    appt.fulfill({ student: 'some student', mentor: 'some mentor' });
    appt.complete!
end