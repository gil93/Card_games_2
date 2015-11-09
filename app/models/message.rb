class Message < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :room, touch: true
end
