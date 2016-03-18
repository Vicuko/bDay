# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 10.times do |n|
# 	user.create
# end


20.times do |n|
	User.create(
		name: Faker::Name.first_name,
		surname: Faker::Name.last_name,
		city: Faker::Address.city,
		country: Faker::Address.country,
		gender: Faker::Boolean.boolean,
		language: "es",
		bday: Date.today,
		email: Faker::Internet.email 
		)
end

10.times do |n|
	Relationship.create(
		user_id: n,
		relationship_id: n+1,
		nickname: User.find(n+1).name
		)
	Relationship.create(
		user_id: n,
		relationship_id: n+2,
		nickname: User.find(n+2).name
		)
end