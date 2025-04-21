namespace :sample do
  desc "Create 100 sample users"
  task users: :environment do
    puts "Creating 100 sample users..."

    100.times do |i|
      User.find_or_create_by!(email: "user#{i+1}@example.com") do |user|
        user.password = 'password123'
        user.password_confirmation = 'password123'
        user.first_name = "User"
        user.last_name = "#{i+1}"
        user.role = 'user'
        user.phone_number = "98765#{i.to_s.rjust(5, '0')}"
      end
    end

    puts "100 sample users created successfully!"
  end
end
