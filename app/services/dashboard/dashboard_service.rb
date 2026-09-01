class Dashboard::DashboardService
  def initialize(user = nil)
    @user = user
  end

  def call
    {
      success: true,
      data: {
        date: Date.current,
        greeting: greeting,
        user: {
          id: @user.id,
          first_name: @user.first_name,
          last_name: @user.last_name,
          email: @user.email
        }
      },
      status: :ok
    }
  end

  private

  def greeting
    case Time.current.hour
    when 5..11
      "Good morning"
    when 12..16
      "Good afternoon"
    when 17..20
      "Good evening"
    else
      "Good night"
    end
  end
end
