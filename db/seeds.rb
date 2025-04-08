User.create!(
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  first_name: 'Admin',
  last_name: 'User',
  role: 'admin',
  phone_number: '1234567890'
)

# Import car data
puts "Importing car brands, models, and versions data..."
Rake::Task['import:all'].invoke
