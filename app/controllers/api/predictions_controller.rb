class Api::PredictionsController < Api::ApiController
  skip_before_action :authenticate_user!, only: [:predict]
  def predict
    version = Version.find(prediction_params[:version_id])
    car_info = CarInfo.find_by(name_encoded: version.car_name_encoded)

    predict_service = PredictionService.new(car_info.name, prediction_params[:year_of_manufacture], prediction_params[:mileage])
    response = predict_service.predict

    if response[:status] == 200
      save_prediction_history(car_info.name, prediction_params[:year_of_manufacture], prediction_params[:mileage], response[:body]["predicted_price"], current_api_user.id)  if current_api_user.present?
      render json: response, status: :ok
    else
      render json: response, status: :bad_request
    end
  end

  private

  def prediction_params
    params.permit(:brand_id, :model_id, :version_id, :year_of_manufacture, :mileage)
  end

  def save_prediction_history car_name, year_of_manufacture, mileage, price, user_id
    PredictionHistory.create!(
      car_name: car_name,
      year_of_manufacture: year_of_manufacture,
      mileage: mileage,
      prediction_price: price,
      user_id: user_id
    )
  end
end
