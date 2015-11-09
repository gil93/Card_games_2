class Card < ActiveRecord::Base
  has_many :room_cards
  has_many :rooms, through: :room_cards
  has_many :users, through: :room_cards 
end
