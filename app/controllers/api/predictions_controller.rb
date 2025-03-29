class Api::PredictionsController < Api::ApiController
  skip_before_action :authenticate_user!, only: [:predict]
  def predict
    predict_service = PredictionService.new(*set_prediction_params.values)
    binding
    response = predict_service.predict

    if response[:status] == 200
      save_prediction_history if current_api_user.present?
      render json: response, status: :ok
    else
      render json: response, status: :bad_request
    end
  end

  private

  def set_prediction_params
    params.permit(:car_name, :year_of_manufacture, :mileage)
  end

  def save_prediction_history
    PredictionHistory.create!(
      set_prediction_params.merge(user_id: current_api_user.id)
    )
  end
end
