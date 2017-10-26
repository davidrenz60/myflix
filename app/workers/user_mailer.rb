class UserMailer
  include Sidekiq::Worker

  def perform(id)
    user = User.find(id)
    AppMailer.send_welcome_email(user).deliver
  end
end