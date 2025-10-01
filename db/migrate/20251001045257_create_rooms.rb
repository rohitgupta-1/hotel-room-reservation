class CreateRooms < ActiveRecord::Migration[7.2]
  def change
    create_table :rooms do |t|
      t.integer :floor
      t.string :room_number
      t.boolean :available

      t.timestamps
    end
  end
end
