# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Create a default admin user
# Create or find the admin user
  user = User.find_or_create_by!(email: "test@gmail.com", role: "admin") do |user|
    user.password = "password123"
    user.password_confirmation = "password123"
    user.username = "admin"
  end

  employee = User.find_or_create_by!(email: "test.hr@gmail.com", role: "hr") do |user|
    user.password = "password123"
    user.password_confirmation = "password123"
    user.username = "hr"
  end
  
  # Create or find the employee user
  employee = User.find_or_create_by!(email: "test.employee@gmail.com", role: "employee") do |user|
    user.password = "password123"
    user.password_confirmation = "password123"
    user.username = "test"
  end