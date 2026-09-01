class CleanupRevokedSessionsJob < ApplicationJob
  def perform
    Session.where("status = ? and revoked_at < ?", "revoked", 30.days.ago).delete_all
  end
end
