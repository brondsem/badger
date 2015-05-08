# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Role.find_or_create_by(name: "Sponsor", border_color: "B7D265")
Role.find_or_create_by(name: "Organizer", border_color: "FF0000")
Role.find_or_create_by(name: "Speaker", border_color: "085F82")
Role.find_or_create_by(name: "Volunteer", border_color: "FFA500")
Role.find_or_create_by(name: "Attendee", border_color: "CCCCCC")
