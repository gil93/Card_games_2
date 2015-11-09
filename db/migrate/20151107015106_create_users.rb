class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.integer :score, default: 0
      t.boolean :stay, default: false
      t.boolean :bust, default: false
      t.boolean :win, default: false
      t.boolean :dealer, default: false
      t.integer :wins, default: 0 

      t.belongs_to :room, index: true

      t.timestamps null: false
    end
  end
end
