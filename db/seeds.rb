# Create or find the admin user
# admin = User.find_or_create_by!(email: "techcronus-admin@gmail.com", role: "admin") do |user|
#   user.password = "Password123"
#   user.password_confirmation = "Password123"
#   user.username = "adminuser"
#   user.first_name = "John"
#   user.last_name = "Doe"
#   user.is_active = true
# end

# # Create or find the HR user
# hr = User.find_or_create_by!(email: "techcronus-hr@gmail.com", role: "hr") do |user|
#   user.password = "Password123"
#   user.password_confirmation = "Password123"
#   user.username = "hruser"
#   user.first_name = "Jane"
#   user.last_name = "Smith"
#   user.is_active = true
# end
  
#   users_data = [
#   { email: "emma.johnson@example.com", username: "emma.johnson", first_name: "Emma", last_name: "Johnson" },
#   { email: "noah.williams@example.com", username: "noah.williams", first_name: "Noah", last_name: "Williams" },
#   { email: "olivia.brown@example.com", username: "olivia.brown", first_name: "Olivia", last_name: "Brown" },
#   { email: "liam.davis@example.com", username: "liam.davis", first_name: "Liam", last_name: "Davis" },
#   { email: "ava.martinez@example.com", username: "ava.martinez", first_name: "Ava", last_name: "Martinez" },
#   { email: "mason.taylor@example.com", username: "mason.taylor", first_name: "Mason", last_name: "Taylor" },
#   { email: "isabella.anderson@example.com", username: "isabella.anderson", first_name: "Isabella", last_name: "Anderson" },
#   { email: "ethan.thomas@example.com", username: "ethan.thomas", first_name: "Ethan", last_name: "Thomas" },
#   { email: "sophia.jackson@example.com", username: "sophia.jackson", first_name: "Sophia", last_name: "Jackson" },
#   { email: "james.white@example.com", username: "james.white", first_name: "James", last_name: "White" }
# ]

# users_data.each do |user_data|
#   employee = User.find_or_create_by!(email: user_data[:email], role: "employee") do |user|
#     user.password = "Password123"
#     user.password_confirmation = "Password123"
#     user.username = user_data[:username]
#     user.first_name = user_data[:first_name]
#     user.last_name = user_data[:last_name]
#     user.is_active = true
#   end
# end

# admin = User.find_or_create_by!(email: "admin@example.com", role: "admin") do |user|
#   user.password = "Password123"
#   user.password_confirmation = "Password123"
#   user.username = "admin_user"
#   user.first_name = "John"
#   user.last_name = "Doe"
#   user.is_active = true
# end

# hr_user = User.find_or_create_by!(email: "hr@example.com", role: "hr") do |user|
#   user.password = "Password123"
#   user.password_confirmation = "Password123"
#   user.username = "hr_user"
#   user.first_name = "Jane"
#   user.last_name = "Smith"
#   user.is_active = true
# end

# employee = User.find_or_create_by!(email: "employee@example.com", role: "employee") do |user|
#   user.password = "Password123"
#   user.password_confirmation = "Password123"
#   user.username = "employee_user"
#   user.first_name = "Alice"
#   user.last_name = "Johnson"
#   user.is_active = true
# end

# Creating Dummy Tickets for HR Request

AssetCategory.find_or_create_by!(name: "Monitor")
AssetCategory.find_or_create_by!(name: "Keyboard")
AssetCategory.find_or_create_by!(name: "Mouse")
AssetCategory.find_or_create_by!(name: "Laptop")
AssetCategory.find_or_create_by!(name: "Desktop")
AssetCategory.find_or_create_by!(name: "CPU")
AssetCategory.find_or_create_by!(name: "MAC")
AssetCategory.find_or_create_by!(name: "Laptop")


#Asset.find_or_create_by!(name: "Dell Monitor", asset_category: AssetCategory.find_by(name: "Monitor"), serial_number: "SN123456", purchase_date: Date.today - 1.year, warranty_expiry_date: Date.today + 2.years, status: "available")

require 'csv'

users_csv_path = Rails.root.join('db', 'users.csv')
assets_csv_path = Rails.root.join('db', 'assets.csv')

CSV.foreach(users_csv_path, headers: true) do |row|
  user = User.find_or_initialize_by(email: row['email'])
  user.username     = row['username']
  user.first_name   = row['first_name']
  user.last_name    = row['last_name']
  user.role         = row['role'] || 'employee'
  user.is_active    = row['is_active'].to_s.downcase == 'true'
  user.password     = "PAAssword123"  # Default password for all users
  user.password_confirmation = "PAAssword123"
  user.phone_number = row['phone_number']
  user.save!
end

puts "Users seeded successfully."

CSV.foreach(assets_csv_path, headers: true) do |row|
  category = AssetCategory.find_by(name: row['asset_category'])
  raise "Category '#{row['asset_category']}' not found" unless category

  asset = Asset.find_or_initialize_by(unique_id: row['unique_id'])
  asset.name              = row['name']
  asset.asset_category    = category
  asset.brand             = row['brand']
  asset.model             = row['model']
  asset.specifications    = row['specifications']
  asset.serial_number     = row['serial_number']
  asset.purchase_date     = row['purchase_date']
  asset.warranty_expiry   = row['warranty_expiry']
  asset.status            = 'available' # row['status'] || 'available'
  asset.condition         = row['condition']
  asset.location          = row['location']
  asset.save!

  puts "Asset '#{asset.name}' seeded successfully."

  if row['assigned_email'].present?
    user = User.find_by(email: row['assigned_email'])
    if user
      AssetAssignment.create!(asset: asset, user: user, assigned_at: Time.current, active: true)
      asset.update!(status: 'assigned')
    else
      puts "⚠️ Warning: No user found with email #{row['assigned_email']} for asset #{asset.name}"
    end
  end

end

puts "Assets seeded successfully."
# Create default asset categories
