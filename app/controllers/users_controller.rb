class UsersController < BaseController
  def show
    render json: { data: current_user }, status: :ok
  end

  def update
    if current_user.update(update_user_params)
      render json: { data: current_user }, status: :ok
    else
      render json: { success: false, errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def deactivate
    current_user.update(status: :deactive)
    current_user.sessions.update!(status: :revoked, revoked_at: Time.current)
    head :no_content
  end

  private

  def update_user_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
