class Api::ReportsController < Api::ApiController
  before_action :set_reportable, only: [:create]

  # POST /api/reports
  def create
    @report = current_user.reports.new(report_params)
    @report.reportable = @reportable
    @report.status = 'pending'

    if @report.save
      create_images_by_blob_ids if params[:report][:images].present?
      render json: @report, status: :created, serializer: ReportSerializer
    else
      render json: { errors: @report.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_reportable
    if params[:report][:reportable_type] == 'User'
      @reportable = User.find(params[:report][:reportable_id])
    elsif params[:report][:reportable_type] == 'SalePost'
      @reportable = SalePost.find(params[:report][:reportable_id])
    else
      render json: { error: "Invalid reportable type" }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Reportable not found" }, status: :not_found
  end

  def report_params
    params.require(:report).permit(:reason)
  end

  def create_images_by_blob_ids
    params[:report][:images].each do |image_id|
      upload_image = ActiveStorage::Blob.find_by(id: image_id)
      @report.images.attach(upload_image) if upload_image.present?
    end
  end
end
