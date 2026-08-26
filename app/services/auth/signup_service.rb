class Auth::SignupService
  def self.call(params)
    user = User.new(params)
    if user.save
      { success: true, data: user }
    else
      { success: false, errors: user.errors.full_messages }
    end
  end
end
