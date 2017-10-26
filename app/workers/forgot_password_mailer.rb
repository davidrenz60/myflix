class ForgotPasswordMailer
  include Sidekiq::Worker

  def perform(id)
    user = User.find(id)
    AppMailer.send_forgot_password(user).deliver
  end
end