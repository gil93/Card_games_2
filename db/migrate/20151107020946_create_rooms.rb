class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.belongs_to :room_type, index: true
      t.timestamps null: false
    end
  end
end
