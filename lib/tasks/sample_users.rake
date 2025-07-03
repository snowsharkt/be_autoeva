namespace :sample do
  desc "Create 100 sample users"
  task users: :environment do
    puts "Creating 100 sample users..."
    first_names = %w[An Bình Chi Dũng Dương Giang Hà Hải Hạnh Hòa Huy Khánh Linh Mai Nam Ngọc Phúc Quang Sơn Thảo Trang Tuấn Vân Vy Xuân Yến Tùng Trường Hiếu Hòa Văn Sinh Danh Nam]
    last_names = %w[Nguyễn Trần Lê Phạm Hoàng Huỳnh Phan Vũ Võ Đặng Bùi Đỗ Hồ Ngô Dương Lý Triệu Trần Trương Phan Ma]

    first_email = %w[an binh chi dung duong giang ha hai hanh hoa huy khanh linh mai nam ngoc phuc quang son thao trang tuan van vy xuan yen tung truong hieu hoa van sinh danh nam]
    last_email = %w[nguyen tran le pham hoang huynh phan vu vo dang bui do ho ngo duong ly trieu tran truong phan ma]

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
