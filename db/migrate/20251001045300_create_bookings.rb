class CreateBookings < ActiveRecord::Migration[7.2]
  def change
    create_table :bookings do |t|
      t.string :guest_name
      t.text :room_ids
      t.datetime :booking_date

      t.timestamps
    end
  end
end
