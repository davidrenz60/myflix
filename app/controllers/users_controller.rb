class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def show
    @user = User.find(params[:id])
  end

  def new
    redirect_to home_path if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    registration = UserRegistration.new(@user).register(params[:stripeToken], params[:invitation_token])

    if registration.successful?
      flash[:success] = "You are registered with MyFlix! Please sign in."
      redirect_to sign_in_path
    else
      flash.now[:danger] = registration.error_message
      render :new
    end
  end

  def new_with_invitation
    invitation = Invitation.find_by(token: params[:token])

    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to invalid_token_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end