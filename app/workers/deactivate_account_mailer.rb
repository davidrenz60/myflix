class DeactivateAccountMailer
  include Sidekiq::Worker

  def perform(id)
    user = User.find(id)
    AppMailer.send_account_deactivated(user).deliver
  end
end