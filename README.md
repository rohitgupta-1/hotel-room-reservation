# Hotel Room Reservation System

A Ruby on Rails application that implements an intelligent hotel room reservation system with travel time optimization.

## Features

### Core Functionality
- **Room Management**: 97 rooms across 10 floors (Floors 1-9: 10 rooms each, Floor 10: 7 rooms)
- **Smart Booking Algorithm**: Automatically selects optimal rooms to minimize travel time
- **Travel Time Calculation**: 
  - Horizontal travel: 1 minute per room
  - Vertical travel: 2 minutes per floor
- **Booking Rules**: Maximum 5 rooms per booking, priority to same-floor bookings

### User Interface
- **Visual Hotel Layout**: Interactive floor-by-floor room visualization
- **Booking Form**: Simple interface to enter guest name and number of rooms
- **Booking Management**: View, cancel, and track all bookings
- **Random Occupancy Generator**: Simulate hotel occupancy for testing
- **Reset Functionality**: Clear all bookings and reset room availability

## Hotel Structure

### Room Distribution
- **Floors 1-9**: 10 rooms each (101-110, 201-210, ..., 901-910)
- **Floor 10**: 7 rooms (1001-1007)
- **Total**: 97 rooms

### Building Layout
- Stairs and lift on the left side of each floor
- Rooms arranged sequentially from left to right
- First room on each floor is closest to stairs/lift

## Booking Algorithm

The system uses an intelligent algorithm to select optimal rooms:

1. **Same Floor Priority**: First attempts to find rooms on the same floor
2. **Travel Time Optimization**: If same floor is not possible, selects rooms that minimize total travel time
3. **Cross-Floor Booking**: When spanning multiple floors, prioritizes rooms that minimize combined vertical and horizontal travel time

### Example Scenarios

**Scenario 1**: Booking 4 rooms
- Available: Floor 1 (101, 102, 105, 106), Floor 2 (201, 202, 203, 210), Floor 3 (301, 302)
- Selection: Rooms 101, 102, 105, 106 (minimizes travel time on same floor)

**Scenario 2**: Booking 2 rooms when only 2 available on Floor 1
- Available: Floor 1 (101, 102), Floor 2 (201, 202, 203, 210)
- Selection: Rooms 201, 202 (minimizes vertical + horizontal travel time)

## Getting Started

### Prerequisites
- Ruby 3.0+
- Rails 7.2+
- SQLite3

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   bundle install
   ```

3. Set up the database:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Start the server:
   ```bash
   rails server
   ```

5. Visit `http://localhost:3000` in your browser

### Usage

1. **View Hotel Layout**: The main page shows a visual representation of all hotel floors and rooms
2. **Book Rooms**: Click "Book Rooms" to create a new reservation
3. **Generate Random Occupancy**: Use the "Generate Random Occupancy" button to simulate hotel occupancy
4. **Reset Bookings**: Use "Reset All Bookings" to clear all reservations
5. **View Bookings**: Navigate to "All Bookings" to see and manage existing reservations

## API Endpoints

- `GET /` - Hotel room visualization
- `GET /rooms` - Room listing and visualization
- `GET /rooms/:id` - Individual room details
- `POST /rooms/generate_random_occupancy` - Generate random occupancy
- `POST /rooms/reset_all_bookings` - Reset all bookings
- `GET /bookings` - List all bookings
- `GET /bookings/new` - New booking form
- `POST /bookings` - Create new booking
- `GET /bookings/:id` - Booking details
- `DELETE /bookings/:id` - Cancel booking

## Technical Details

### Models
- **Room**: Represents individual hotel rooms with floor, room number, and availability
- **Booking**: Tracks reservations with guest information and room assignments

### Key Methods
- `Room.initialize_hotel_rooms`: Creates all 97 hotel rooms
- `Room.travel_time_to(other_room)`: Calculates travel time between rooms
- `Booking.find_optimal_rooms(room_count)`: Finds best room combination
- `Booking.total_travel_time`: Calculates total travel time for a booking

### Database Schema
- **rooms**: floor (integer), room_number (string), available (boolean)
- **bookings**: guest_name (string), room_ids (text), booking_date (datetime)

## Testing the System

1. Start with all rooms available
2. Generate random occupancy to simulate real hotel conditions
3. Try booking different numbers of rooms (1-5)
4. Observe how the system selects optimal rooms
5. Check travel time calculations in booking details
6. Test cross-floor bookings when same-floor rooms are unavailable

## Future Enhancements

- Advanced booking algorithms (genetic algorithms, simulated annealing)
- Real-time availability updates
- Guest preferences and room types
- Integration with payment systems
- Mobile-responsive design improvements
- Booking history and analytics