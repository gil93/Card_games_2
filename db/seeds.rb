# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

room_types = [
  "BlackJack",
  "Poker"
]

cards = Dir["*/assets/images/*.png"]

cards.each do |card|
  value = card.split("app/assets/images/").pop.split("_of_").shift
  suit = card.split("app/assets/images/").pop.split("_of_").pop.gsub('.png', '')
  image = card.gsub("app/assets/images/", "")

  Card.create(value: value, suit: suit, image: image) if !Card.find_by_image(image)
end

room_types.each do |room_type|
  RoomType.create(category: room_type) if !RoomType.find_by_category(room_type)
end
