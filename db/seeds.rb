puts "Creating admin user..."
User.create!(
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  first_name: 'Admin',
  last_name: 'User',
  role: 'admin',
  phone_number: '1234567890',
  confirmed_at: Time.now
)

# Create sample users
puts "Creating sample users..."
Rake::Task['sample:users'].invoke

# Import car data
puts "Importing car, posts, data..."
Rake::Task['import:all'].invoke
