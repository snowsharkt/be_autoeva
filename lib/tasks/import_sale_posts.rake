require 'csv'

namespace :import do
  desc "Import sale posts from CSV file"
  task sale_posts: :environment do
    regular_users = User.where(role: 'user')

    if regular_users.empty?
      puts "No regular users found. Creating sample users first..."
      Rake::Task['sample:users'].invoke
      regular_users = User.where(role: 'user')
    end

    sale_posts_file = Rails.root.join('db/data/bonbanh_car_details.csv')

    CSV.foreach(sale_posts_file, headers: true) do |row|
      selected_user = regular_users.sample

      sale_post = SalePost.find_or_create_by!(id: row['sale_post_id']) do |post|
        post.user_id = selected_user.id
        post.brand_id = row['brand_id']
        post.model_id = row['model_id']
        post.version_id = row['version_id']
        post.title = row['title']
        post.description = row['description']
        post.price = row['price']
        post.year = row['year']
        post.odo = row['odo']
        post.location = row['location']
        post.status = row['status'] || 'active'
      end

      puts "Imported sale post ID: #{sale_post.id} assigned to user: #{selected_user.email}"
    end

    puts "Sale posts imported successfully!"
  end

  desc "Import sale post images from CSV file"
  task sale_post_images: :environment do
    images_file = Rails.root.join('db/data/bonbanh_car_images.csv')

    CSV.foreach(images_file, headers: true) do |row|
      SalePostImage.find_or_create_by!(sale_post_id: row[0], image_url: row[0])
    end

    puts "Sale post images imported successfully!"
  end

  desc "Import only sale posts and their images"
  task sale_posts_data: :environment do
    Rake::Task['import:sale_posts'].invoke
    Rake::Task['import:sale_post_images'].invoke
    puts "Sale posts and images imported successfully!"
  end
end
