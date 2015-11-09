class CreateRoomCards < ActiveRecord::Migration
  def change
    create_table :room_cards do |t|
      t.belongs_to :card, index: true
      t.belongs_to :room, index: true
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
end
