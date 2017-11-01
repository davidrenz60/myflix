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

    if @user.save
      charge = StripeWrapper::Charge.create(
        amount: 999,
        description: "sign up charge for #{@user.full_name}",
        source: params[:stripeToken]
      )

      if charge.successful?
        handle_invitations
        UserMailer.perform_async(@user.id)
        redirect_to sign_in_path
      else
        flash[:danger] = charge.error_message
        redirect_to register_path
      end
    else
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

  def handle_invitations
    if params[:invitation_token].present?
      invitation = Invitation.find_by(token: params[:invitation_token])
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end
end