class User < ActiveRecord::Base

  belongs_to :room, touch: true, autosave: true

  has_many :messages
  has_many :room_cards
  has_many :cards, through: :room_cards

  has_secure_password

  validates :email, presence: true, uniqueness: true
	validates :password, presence: true

end
