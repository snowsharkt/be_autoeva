class Admin::ReportsController < AdminController
  before_action :set_report, only: [:show, :update, :destroy]

  # GET /admin/reports
  def index
    @reports = Report.includes(:reporter, :reportable)
                     .order(created_at: :desc)
  end

  # GET /admin/reports/:id
  def show
  end

  # PATCH/PUT /admin/reports/:id
  def update
    if @report.update(report_params)
      redirect_to admin_report_path(@report), notice: 'Report was successfully updated.'
    else
      render :show
    end
  end

  # DELETE /admin/reports/:id
  def destroy
    @report.destroy
    redirect_to admin_reports_path, notice: 'Report was successfully deleted.'
  end

  # POST /admin/reports/:id/resolve
  def resolve
    @report = Report.find(params[:id])
    @report.status = 'resolved'

    if @report.save
      redirect_to admin_reports_path, notice: 'Report was marked as resolved.'
    else
      redirect_to admin_reports_path, alert: 'Could not resolve report.'
    end
  end

  # POST /admin/reports/:id/reject
  def reject
    @report = Report.find(params[:id])
    @report.status = 'rejected'

    if @report.save
      redirect_to admin_reports_path, notice: 'Report was rejected.'
    else
      redirect_to admin_reports_path, alert: 'Could not reject report.'
    end
  end

  # POST /admin/reports/:id/ban_user
  def ban_user
    @report = Report.find(params[:id])

    if @report.reportable_type == 'User'
      user = @report.reportable
      user.update(role: 'banned') if user.role == 'user'
      @report.update(status: 'resolved')

      redirect_to admin_reports_path, notice: 'User was banned and report was resolved.'
    else
      redirect_to admin_reports_path, alert: 'Cannot ban user for this report type.'
    end
  end

  # POST /admin/reports/:id/delete_post
  def delete_post
    @report = Report.find(params[:id])

    if @report.reportable_type == 'SalePost'
      post = @report.reportable
      post.discard if post.present?
      @report.update(status: 'resolved')

      redirect_to admin_reports_path, notice: 'Post was deleted and report was resolved.'
    else
      redirect_to admin_reports_path, alert: 'Cannot delete post for this report type.'
    end
  end

  private

  def set_report
    @report = Report.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_reports_path, alert: 'Report not found.'
  end

  def report_params
    params.require(:report).permit(:status)
  end
end
