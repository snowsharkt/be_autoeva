require 'net/http'
require 'uri'
require 'json'

class PredictionService
  def initialize car_name, year_of_manufacture, mileage
    @car_name = car_name
    @year_of_manufacture = year_of_manufacture
    @mileage = mileage
  end

  def predict
    if @car_name.blank? || @year_of_manufacture.blank? || @mileage.blank?
      return {
        status: 400,
        body: "Please provide full data for prediction"
      }
    end

    base_url = ENV["PREDICT_API_URL"] || "http://localhost:8000"
    url = URI.parse("#{base_url}/predict/?car_name=#{@car_name}&year_of_manufacture=#{@year_of_manufacture}&mileage=#{@mileage}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == "https")
    begin
      request = Net::HTTP::Post.new(url)
      response = http.request(request)
      data = JSON.parse(response.body)
      {
        status: response.code.to_i,
        body: data
      }
    rescue => e
      Rails.logger.error "Error in prediction service: #{e.message}"
      {
        status: 500,
        body: "Prediction service is unavailable"
      }
    end
  end
end
