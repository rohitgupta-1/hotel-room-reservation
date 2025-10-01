# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Initialize hotel rooms
puts "Initializing hotel rooms..."
Room.initialize_hotel_rooms
puts "Hotel rooms initialized successfully!"
puts "Total rooms created: #{Room.count}"
puts "Available rooms: #{Room.where(available: true).count}"
