class BaseController < ApplicationController
  before_action :authenticate_user!
  attr_reader :current_user

  def me
    render json: { data: current_user }, status: :ok
  end

  private

  def authenticate_user!
    header = request.headers["Authorization"]
    return render_unauthorized("Authorizaation header is missing") unless header
    return render_unauthorized("Invalid Authorization header") unless header.start_with?("Bearer ")
    token = header.split(" ", 2).last
    return render_unauthorized("Access Token is missing") unless token
    payload = Auth::JwtService.decode(token)
    @current_user ||= User.find_by(id: payload["user_id"])
    return render_unauthorized("User not found") unless @current_user
    return render_unauthorized("User Account not activated") unless @current_user.active?
    @current_session = Session.find_by(id: payload["session_id"])
    return render_unauthorized("User Session not found") unless @current_session
    render_unauthorized("Please Sign In Again") if @current_session.revoked?
  rescue JWT::ExpiredSignature
    render_unauthorized("Access Token expired")
  rescue JWT::DecodeError
    render_unauthorized("Invalid access token")
  end

  def render_unauthorized(message)
    render json: {
      success: false,
      errors: message,
      status: :unauthorized
    }
  end
end
