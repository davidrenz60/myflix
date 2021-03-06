class SessionsController < ApplicationController
  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        flash[:success] = "Welcome #{user.full_name}! You are signed in."
        redirect_to home_path
      else
        flash[:danger] = "Your account has been deactivated. Please contact customer service."
        redirect_to sign_in_path
      end
    else
      flash[:danger] = "Incorrect email or password. Please try again."
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have signed out."
    redirect_to root_path
  end
end
