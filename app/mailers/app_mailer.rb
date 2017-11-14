class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail from: "info@myflix.com", to: user.email, subject: "Welcome to MyFLix"
  end

  def send_forgot_password(user)
    @user = user
    mail from: "info@myflix.com", to: user.email, subject: "Reset Password"
  end

  def send_invitation(invitation)
    @invitation = invitation
    mail from: "info@myflix.com", to: invitation.recipient_email, subject: "Invitation to join MyFlix"
  end

  def send_account_deactivated(user)
    mail from: "info@myflix.com", to: user.email, subject: "Invitation to join MyFlix"
  end
end
