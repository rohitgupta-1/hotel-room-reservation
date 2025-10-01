class RoomsController < ApplicationController
  def index
    # Initialize hotel rooms if none exist
    Room.initialize_hotel_rooms if Room.count == 0
    
    @rooms = Room.ordered
    @rooms_by_floor = @rooms.group_by(&:floor)
  end

  def show
    @room = Room.find(params[:id])
  end
  
  def generate_random_occupancy
    # Reset all rooms to available
    Room.update_all(available: true)
    
    # Randomly occupy 30-60% of rooms
    total_rooms = Room.count
    occupied_count = rand(30..60) * total_rooms / 100
    
    # Randomly select rooms to occupy
    rooms_to_occupy = Room.order("RANDOM()").limit(occupied_count)
    rooms_to_occupy.update_all(available: false)
    
    redirect_to rooms_path, notice: "Generated random occupancy for #{occupied_count} rooms"
  end
  
  def reset_all_bookings
    # Reset all rooms to available
    Room.update_all(available: true)
    
    # Clear all bookings
    Booking.destroy_all
    
    redirect_to rooms_path, notice: "All bookings have been reset"
  end
end
