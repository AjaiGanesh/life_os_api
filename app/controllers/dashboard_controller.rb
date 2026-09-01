class DashboardController < BaseController
  def show
    result = Dashboard::DashboardService.new(current_user).call
    if result[:success]
      render json: result, status: result[:status]
    else
      render json: result, status: result[:status]
    end
  end
end
