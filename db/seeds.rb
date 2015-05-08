# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Role.find_or_create_by(name: "Sponsor")
Role.find_or_create_by(name: "Organizer")
Role.find_or_create_by(name: "Speaker")
Role.find_or_create_by(name: "Volunteer")
Role.find_or_create_by(name: "Attendee")
