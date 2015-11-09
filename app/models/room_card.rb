class RoomCard < ActiveRecord::Base
  belongs_to :room, touch: true
  belongs_to :card, touch: true
  belongs_to :user, touch: true 
end
