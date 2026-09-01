class AuthController < BaseController
  skip_before_action :authenticate_user!, except: [ :sign_out, :sign_out_all, :change_password ]
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

  def sign_in
    result = Auth::SigninService.call(params.require(:email), params.require(:password))
    if result[:success]
      render json: result, status: result[:status]
    else
      render json: result, status: result[:status]
    end
  end

  def refresh
    result = Auth::RefreshTokenService.call(request.headers["Authorization"])
    if result[:success]
      render json: result, status: result[:status]
    else
      render json: result, status: result[:status]
    end
  end


  def sign_out
    @current_session.update!(status: :revoked, revoked_at: Time.current)
    head :no_content
  end

  def sign_out_all
    current_user.sessions.update!(status: :revoked, revoked_at: Time.current)
    head :no_content
  end

  def forgot_password
    result = Auth::ForgotPasswordService.call(params[:email])
    if result[:success]
      render json: result, status: result[:status]
    else
      render json: result, status: result[:status]
    end
  end

  def reset_password
    result = Auth::ResetPasswordService.call(params[:password], params[:password_confirmation], params[:token])
    if result[:success]
      render json: result, status: result[:status]
    else
      render json: result, status: result[:status]
    end
  end

  def change_password
    result = Auth::ChangePasswordService.call(params[:current_password], params[:password], params[:password_confirmation], current_user)
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
