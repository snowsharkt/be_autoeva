module Admin
  class DashboardController < AdminController
    def index
      @users_count = User.count
      @admins_count = User.where(role: 'admin').count
    end
  end
end
