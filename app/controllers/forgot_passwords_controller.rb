class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user
      user.generate_token
      AppMailer.send_forgot_password(user).deliver
      redirect_to forgot_password_confirmation_path
    else
      flash[:danger] = params[:email].blank? ? "Email cannot be blank." : "Email address not found."
      redirect_to forgot_password_path
    end
  end
end