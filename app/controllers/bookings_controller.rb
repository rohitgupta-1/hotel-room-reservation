class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :destroy]
  
  def index
    @bookings = Booking.includes(:rooms).order(created_at: :desc)
  end
  
  def new
    @booking = Booking.new
  end

  def create
    room_count = params[:room_count].to_i
    
    if room_count <= 0 || room_count > 5
      redirect_to new_booking_path, alert: "Please enter a valid number of rooms (1-5)"
      return
    end
    
    optimal_rooms = Booking.find_optimal_rooms(room_count)
    
    if optimal_rooms.empty?
      redirect_to new_booking_path, alert: "Sorry, not enough rooms available for your request"
      return
    end
    
    @booking = Booking.new(
      guest_name: params[:guest_name],
      room_ids: optimal_rooms.map(&:id),
      booking_date: Time.current
    )
    
    if @booking.save
      # Mark rooms as unavailable
      optimal_rooms.each { |room| room.update!(available: false) }
      
      redirect_to rooms_path, notice: "Successfully booked #{room_count} rooms for #{@booking.guest_name}. Total travel time: #{@booking.total_travel_time} minutes"
    else
      redirect_to new_booking_path, alert: "Failed to create booking: #{@booking.errors.full_messages.join(', ')}"
    end
  end

  def show
  end

  def destroy
    # Mark rooms as available again
    @booking.rooms.each { |room| room.update!(available: true) }
    
    @booking.destroy
    redirect_to bookings_path, notice: "Booking cancelled successfully"
  end
  
  private
  
  def set_booking
    @booking = Booking.find(params[:id])
  end
end
