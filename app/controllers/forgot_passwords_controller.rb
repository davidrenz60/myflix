class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user
      ForgotPasswordMailer.perform_async(user.id)
      redirect_to forgot_password_confirmation_path
    else
      flash[:danger] = params[:email].blank? ? "Email cannot be blank." : "Email address not found."
      redirect_to forgot_password_path
    end
  end
end