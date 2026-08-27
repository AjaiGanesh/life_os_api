class AuthController < BaseController
  def sign_up
    result = Auth::SignupService.call(signup_params)
    if result[:success]
      render json: result, status: result[:status]
    else
      render json: result, status: result[:status]
    end
  end

  def verify_email
    token = params.require(:token)
    result = Auth::VerifyEmailService.call(token)
    if result[:success]
      render json: result, status: result[:status]
    else
      render json: result, status: result[:status]
    end
  end

  private

  def signup_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
