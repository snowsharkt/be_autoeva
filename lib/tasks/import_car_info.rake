require 'csv'

namespace :import do
  desc "Import brands from CSV file"
  task brands: :environment do
    CSV.foreach(Rails.root.join('db/data/brands.csv'), headers: true) do |row|
      Brand.find_or_create_by!(id: row['id']) do |brand|
        brand.name = row['name']
      end
    end
    puts "Brands imported successfully!"
  end

  desc "Import models from CSV file"
  task models: :environment do
    CSV.foreach(Rails.root.join('db/data/models.csv'), headers: true) do |row|
      Model.find_or_create_by!(id: row['id']) do |model|
        model.brand_id = row['brand_id']
        model.name = row['name']
      end
    end
    puts "Models imported successfully!"
  end

  desc "Import versions from CSV file"
  task versions: :environment do
    CSV.foreach(Rails.root.join('db/data/versions.csv'), headers: true) do |row|
      Version.find_or_create_by!(id: row['id']) do |version|
        version.model_id = row['model_id']
        version.name = row['name']
        version.origin = row['origin']
        version.transmission = row['transmission']
        version.fuel_type = row['fuel_type']
        version.engine_capacity = row['engine_capacity']
        version.seats = row['seats']
        version.car_name_encoded = row['car_name_encoded']
      end
    end
    puts "Versions imported successfully!"
  end

  desc "Import car's info from CSV file"
  task car_info: :environment do
    CSV.foreach(Rails.root.join('db/data/car_info.csv'), headers: true) do |row|
      CarInfo.find_or_create_by!(name: row['car_name']) do |car|
        car.name = row['car_name']
        car.name_encoded = row['car_name_encoded']
      end
    end
    puts "Car info imported successfully!"
  end

  desc "Import all data from CSV files in proper order"
  task all: :environment do
    Rake::Task['import:brands'].invoke
    Rake::Task['import:models'].invoke
    Rake::Task['import:versions'].invoke
    Rake::Task['import:car_info'].invoke
    puts "All data imported successfully!"
  end
end
