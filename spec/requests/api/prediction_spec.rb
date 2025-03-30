require 'swagger_helper'

RSpec.describe "Prediction API" do
  path '/api/predicts' do
    post 'Predict price' do
      tags 'Pridiction'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          car_name: { type: :string, example: 'Toyota Land Cruiser VX 4.6 V8' },
          year_of_manufacture: { type: :integer, example: 2020 },
          mileage: { type: :integer, example: 10000 },
        },
        required: %w[car_name year_of_manufacture mileage],
      }

      response '200', :success do
        run_test!
      end
    end
  end

end
