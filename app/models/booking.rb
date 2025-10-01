class Booking < ApplicationRecord
  validates :guest_name, presence: true
  validates :room_ids, presence: true
  validates :booking_date, presence: true
  
  serialize :room_ids, coder: JSON
  
  def rooms
    Room.where(id: room_ids)
  end
  
  def total_travel_time
    return 0 if rooms.count <= 1
    
    # Calculate total travel time between all rooms in the booking
    total_time = 0
    room_list = rooms.order(:floor, :room_number)
    
    (0...room_list.count - 1).each do |i|
      total_time += room_list[i].travel_time_to(room_list[i + 1])
    end
    
    total_time
  end
  
  def self.find_optimal_rooms(room_count)
    return [] if room_count <= 0 || room_count > 5
    
    available_rooms = Room.available.order(:floor, :room_number)
    return [] if available_rooms.empty?
    
    # Group available rooms by floor
    rooms_by_floor = available_rooms.group_by(&:floor)
    
    # Try to find rooms on the same floor first
    rooms_by_floor.each do |floor, rooms|
      if rooms.count >= room_count
        # Try different combinations on this floor to minimize travel time
        best_combination = find_best_combination_on_floor(rooms, room_count)
        return best_combination if best_combination.any?
      end
    end
    
    # If not enough rooms on any single floor, find optimal combination across floors
    find_optimal_cross_floor_combination(available_rooms, room_count)
  end
  
  private
  
  def self.find_best_combination_on_floor(rooms, room_count)
    return [] if rooms.count < room_count
    
    # Sort rooms by position on floor
    sorted_rooms = rooms.sort_by(&:position_on_floor)
    
    best_combination = []
    min_travel_time = Float::INFINITY
    
    # Try consecutive room combinations
    (0..sorted_rooms.count - room_count).each do |start_index|
      combination = sorted_rooms[start_index, room_count]
      travel_time = calculate_combination_travel_time(combination)
      
      if travel_time < min_travel_time
        min_travel_time = travel_time
        best_combination = combination
      end
    end
    
    best_combination
  end
  
  def self.find_optimal_cross_floor_combination(available_rooms, room_count)
    # This is a simplified approach - in a real system, you'd want a more sophisticated algorithm
    # For now, we'll prioritize rooms that are closest to each other
    
    best_combination = []
    min_travel_time = Float::INFINITY
    
    # Try combinations starting from each available room
    available_rooms.each do |starting_room|
      combination = [starting_room]
      remaining_rooms = available_rooms - [starting_room]
      
      # Greedily add the closest room until we have enough
      while combination.count < room_count && remaining_rooms.any?
        closest_room = remaining_rooms.min_by do |room|
          combination.sum { |existing_room| existing_room.travel_time_to(room) }
        end
        
        combination << closest_room
        remaining_rooms.delete(closest_room)
      end
      
      if combination.count == room_count
        travel_time = calculate_combination_travel_time(combination)
        if travel_time < min_travel_time
          min_travel_time = travel_time
          best_combination = combination
        end
      end
    end
    
    best_combination
  end
  
  def self.calculate_combination_travel_time(rooms)
    return 0 if rooms.count <= 1
    
    total_time = 0
    sorted_rooms = rooms.sort_by { |room| [room.floor, room.position_on_floor] }
    
    (0...sorted_rooms.count - 1).each do |i|
      total_time += sorted_rooms[i].travel_time_to(sorted_rooms[i + 1])
    end
    
    total_time
  end
end
