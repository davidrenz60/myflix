class ResetPasswordsController < ApplicationController
  def show
    user = User.find_by(token: params[:id])

    if user
      @token = user.token
    else
      redirect_to invalid_token_path
    end
  end

  def create
    token = params[:token]
    user = User.find_by(token: params[:token])

    if user && token
      user.password = params[:password]

      if user.save
        user.clear_token
        flash[:success] = "Password changed. Please log in."
        redirect_to sign_in_path
      else
        flash[:danger] = "There was a problem updating your password."
        redirect_to reset_password_path(user.token)
      end
    else
      redirect_to invalid_token_path
    end
  end
end