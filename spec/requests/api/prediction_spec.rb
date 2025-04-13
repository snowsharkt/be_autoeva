require 'swagger_helper'

RSpec.describe "Prediction API" do
  path '/api/predicts' do
    post 'Predict price' do
      tags 'Pridiction'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          brand_id: { type: :integer, example: 1 },
          model_id: { type: :integer, example: 1 },
          version_id: { type: :integer, example: 1 },
          year_of_manufacture: { type: :integer, example: 2020 },
          mileage: { type: :integer, example: 10000 },
        },
        required: %w[brand_id model_id version_id year_of_manufacture mileage],
      }

      response '200', :success do
        run_test!
      end
    end
  end

end
