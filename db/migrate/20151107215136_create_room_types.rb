class CreateRoomTypes < ActiveRecord::Migration
  def change
    create_table :room_types do |t|
      t.string :category
      t.timestamps null: false
    end
  end
end
