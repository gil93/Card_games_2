class Room < ActiveRecord::Base

  belongs_to :room_type, touch: true
  has_many :messages
  has_many :users

  has_many :room_cards
  has_many :cards, through: :room_cards

  accepts_nested_attributes_for :users 
end
