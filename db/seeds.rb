# Create or find the admin user
admin = User.find_or_create_by!(email: "techcronus-admin@gmail.com", role: "admin") do |user|
  user.password = "Password123"
  user.password_confirmation = "Password123"
  user.username = "adminuser"
  user.first_name = "John"
  user.last_name = "Doe"
  user.is_active = true
end

# Create or find the HR user
hr = User.find_or_create_by!(email: "techcronus-hr@gmail.com", role: "hr") do |user|
  user.password = "Password123"
  user.password_confirmation = "Password123"
  user.username = "hruser"
  user.first_name = "Jane"
  user.last_name = "Smith"
  user.is_active = true
end
  
  users_data = [
  { email: "emma.johnson@example.com", username: "emma.johnson", first_name: "Emma", last_name: "Johnson" },
  { email: "noah.williams@example.com", username: "noah.williams", first_name: "Noah", last_name: "Williams" },
  { email: "olivia.brown@example.com", username: "olivia.brown", first_name: "Olivia", last_name: "Brown" },
  { email: "liam.davis@example.com", username: "liam.davis", first_name: "Liam", last_name: "Davis" },
  { email: "ava.martinez@example.com", username: "ava.martinez", first_name: "Ava", last_name: "Martinez" },
  { email: "mason.taylor@example.com", username: "mason.taylor", first_name: "Mason", last_name: "Taylor" },
  { email: "isabella.anderson@example.com", username: "isabella.anderson", first_name: "Isabella", last_name: "Anderson" },
  { email: "ethan.thomas@example.com", username: "ethan.thomas", first_name: "Ethan", last_name: "Thomas" },
  { email: "sophia.jackson@example.com", username: "sophia.jackson", first_name: "Sophia", last_name: "Jackson" },
  { email: "james.white@example.com", username: "james.white", first_name: "James", last_name: "White" }
]

users_data.each do |user_data|
  employee = User.find_or_create_by!(email: user_data[:email], role: "employee") do |user|
    user.password = "Password123"
    user.password_confirmation = "Password123"
    user.username = user_data[:username]
    user.first_name = user_data[:first_name]
    user.last_name = user_data[:last_name]
    user.is_active = true
  end
end

admin = User.find_or_create_by!(email: "admin@example.com", role: "admin") do |user|
  user.password = "Password123"
  user.password_confirmation = "Password123"
  user.username = "admin_user"
  user.first_name = "John"
  user.last_name = "Doe"
  user.is_active = true
end

hr_user = User.find_or_create_by!(email: "hr@example.com", role: "hr") do |user|
  user.password = "Password123"
  user.password_confirmation = "Password123"
  user.username = "hr_user"
  user.first_name = "Jane"
  user.last_name = "Smith"
  user.is_active = true
end

employee = User.find_or_create_by!(email: "employee@example.com", role: "employee") do |user|
  user.password = "Password123"
  user.password_confirmation = "Password123"
  user.username = "employee_user"
  user.first_name = "Alice"
  user.last_name = "Johnson"
  user.is_active = true
end

# Creating Dummy Tickets for HR Request

Ticket.find_or_create_by!(user: employee, title: "Request for Leave", description: "I would like to request 3 days of leave from April 15 to April 17.", status: "open", priority: "high")
Ticket.find_or_create_by!(user: employee, title: "Salary Slip Request", description: "Can you please send me my salary slip for the last month?", status: "open", priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Update on Employee Benefits", description: "Please provide an update on the new employee benefits package.", status: "open", priority: "low")
Ticket.find_or_create_by!(user: admin, title: "IT Support Needed", description: "I need assistance with my laptop setup.", status: "open", priority: "high")
Ticket.find_or_create_by!(user: employee, title: "Feedback on Training Session", description: "I would like to provide feedback on the recent training session.", status: "open", priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Salary Inquiry", description: "Can you please confirm the date for the next salary payment?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Request for HR Policy Document", description: "Can you send me the latest HR policy document?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Work from Home", description: "I would like to request work from home for the next week.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Employee Feedback Survey", description: "Please send out the employee feedback survey for this quarter.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Office Supplies", description: "I need some office supplies for my workstation.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Update on Recruitment Process", description: "Please provide an update on the recruitment process for the new positions.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Performance Review", description: "Can I get a performance review scheduled for this month?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: admin, title: "Update on HR Policies", description: "Please update the team on the changes in HR policies regarding work from home.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Request for HR Policy Document", description: "Can you send me the latest HR policy document?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Work from Home", description: "I would like to request work from home for the next week.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Employee Feedback Survey", description: "Please send out the employee feedback survey for this quarter.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Office Supplies", description: "I need some office supplies for my workstation.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Update on Recruitment Process", description: "Please provide an update on the recruitment process for the new positions.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Performance Review", description: "Can I get a performance review scheduled for this month?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Request for Training", description: "Can I get approval for a training session on leadership skills for the team?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Request for HR Policy Document", description: "Can you send me the latest HR policy document?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Work from Home", description: "I would like to request work from home for the next week.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Employee Feedback Survey", description: "Please send out the employee feedback survey for this quarter.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Office Supplies", description: "I need some office supplies for my workstation.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Update on Recruitment Process", description: "Please provide an update on the recruitment process for the new positions.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Performance Review", description: "Can I get a performance review scheduled for this month?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "System Access Issue", description: "I'm unable to access the HR portal. Can you help?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Request for HR Policy Document", description: "Can you send me the latest HR policy document?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Work from Home", description: "I would like to request work from home for the next week.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Employee Feedback Survey", description: "Please send out the employee feedback survey for this quarter.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Office Supplies", description: "I need some office supplies for my workstation.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Update on Recruitment Process", description: "Please provide an update on the recruitment process for the new positions.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Performance Review", description: "Can I get a performance review scheduled for this month?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: admin, title: "Annual Performance Review", description: "Please ensure that the annual performance review forms are sent to all employees.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Request for HR Policy Document", description: "Can you send me the latest HR policy document?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Work from Home", description: "I would like to request work from home for the next week.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Employee Feedback Survey", description: "Please send out the employee feedback survey for this quarter.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Office Supplies", description: "I need some office supplies for my workstation.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Update on Recruitment Process", description: "Please provide an update on the recruitment process for the new positions.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Performance Review", description: "Can I get a performance review scheduled for this month?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Working Hours Clarification", description: "Can HR clarify the new working hours for the team?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Request for HR Policy Document", description: "Can you send me the latest HR policy document?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Work from Home", description: "I would like to request work from home for the next week.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Employee Feedback Survey", description: "Please send out the employee feedback survey for this quarter.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Office Supplies", description: "I need some office supplies for my workstation.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Update on Recruitment Process", description: "Please provide an update on the recruitment process for the new positions.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Performance Review", description: "Can I get a performance review scheduled for this month?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "New Employee Onboarding", description: "We need to onboard new employees for the upcoming month. Can you prepare the documents?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Request for HR Policy Document", description: "Can you send me the latest HR policy document?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Work from Home", description: "I would like to request work from home for the next week.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Employee Feedback Survey", description: "Please send out the employee feedback survey for this quarter.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Office Supplies", description: "I need some office supplies for my workstation.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Update on Recruitment Process", description: "Please provide an update on the recruitment process for the new positions.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Performance Review", description: "Can I get a performance review scheduled for this month?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: admin, title: "Team Event Approval", description: "Requesting approval for a team-building event in May.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Request for HR Policy Document", description: "Can you send me the latest HR policy document?", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Work from Home", description: "I would like to request work from home for the next week.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Employee Feedback Survey", description: "Please send out the employee feedback survey for this quarter.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Office Supplies", description: "I need some office supplies for my workstation.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: hr_user, title: "Update on Recruitment Process", description: "Please provide an update on the recruitment process for the new positions.", status: "open" , priority: "medium")
Ticket.find_or_create_by!(user: employee, title: "Request for Performance Review", description: "Can I get a performance review scheduled for this month?", status: "open" , priority: "medium")

