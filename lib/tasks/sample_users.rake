namespace :sample do
  desc "Create 100 sample users"
  task users: :environment do
    puts "Creating 100 sample users..."

    100.times do |i|
      first_name = first_names.sample
      last_name = last_names.sample

      first_index = first_names.index(first_name)
      last_index = last_names.index(last_name)

      email_name = "#{first_email[first_index]}#{last_email[last_index]}"
      email = "#{email_name}#{rand(1000..9999)}@gmail.com"

      puts "Tên đầy đủ: #{last_name} #{first_name}"
      puts "Email: #{email}"

      User.find_or_create_by!(email: email) do |user|
        user.password = 'password123'
        user.password_confirmation = 'password123'
        user.first_name = first_name
        user.last_name = last_name
        user.role = 'user'
        user.phone_number = "03456#{i.to_s.rjust(5, '0')}"
        user.confirmed_at = Time.now
      end
    end

    puts "100 sample users created successfully!"
  end
end
