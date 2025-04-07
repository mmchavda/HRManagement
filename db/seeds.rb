
  user = User.find_or_create_by!(email: "test@gmail.com", role: "admin") do |user|
    user.password = "password123"
    user.password_confirmation = "password123"
    user.username = "admin"
    user.is_active = true 
  end

  employee = User.find_or_create_by!(email: "test.hr@gmail.com", role: "hr") do |user|
    user.password = "password123"
    user.password_confirmation = "password123"
    user.username = "hr"
    user.is_active = true 
  end
  
  # Create or find the employee user
  employee = User.find_or_create_by!(email: "test.employee@gmail.com", role: "employee") do |user|
    user.password = "password123"
    user.password_confirmation = "password123"
    user.username = "test"
    user.is_active = true 
  end

  
  user = User.find_or_create_by!(email: "test2@gmail.com", role: "admin") do |user|
    user.password = "password123"
    user.password_confirmation = "password123"
    user.username = "admin"
    user.is_active = true 
  end

  employee = User.find_or_create_by!(email: "test.hr2@gmail.com", role: "hr") do |user|
    user.password = "password123"
    user.password_confirmation = "password123"
    user.username = "hr"
    user.is_active = true 
  end
  
  # Create or find the employee user
  employee = User.find_or_create_by!(email: "test.employee2@gmail.com", role: "employee") do |user|
    user.password = "password123"
    user.password_confirmation = "password123"
    user.username = "test"
    user.is_active = true 
  end