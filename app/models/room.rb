class Room < ApplicationRecord
  validates :floor, presence: true, inclusion: { in: 1..10 }
  validates :room_number, presence: true, uniqueness: true
  validates :available, inclusion: { in: [true, false] }
  
  scope :available, -> { where(available: true) }
  scope :by_floor, ->(floor) { where(floor: floor) }
  scope :ordered, -> { order(:floor, :room_number) }
  
  def self.initialize_hotel_rooms
    # Clear existing rooms
    Room.delete_all
    
    # Create rooms for floors 1-9 (10 rooms each)
    (1..9).each do |floor|
      (1..10).each do |room_num|
        room_number = "#{floor}#{room_num.to_s.rjust(2, '0')}"
        Room.create!(
          floor: floor,
          room_number: room_number,
          available: true
        )
      end
    end
    
    # Create rooms for floor 10 (7 rooms: 1001-1007)
    (1..7).each do |room_num|
      room_number = "100#{room_num}"
      Room.create!(
        floor: 10,
        room_number: room_number,
        available: true
      )
    end
  end
  
  def position_on_floor
    # Calculate position from left to right on the floor
    if floor == 10
      room_number.to_i - 1000
    else
      room_number.to_i % 100
    end
  end
  
  def travel_time_to(other_room)
    return 0 if self == other_room
    
    # Vertical travel time (2 minutes per floor)
    vertical_time = (floor - other_room.floor).abs * 2
    
    # Horizontal travel time (1 minute per room)
    horizontal_time = (position_on_floor - other_room.position_on_floor).abs
    
    vertical_time + horizontal_time
  end
end
