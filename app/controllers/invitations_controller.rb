class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.inviter = current_user

    if @invitation.save
      AppMailer.send_invitation(@invitation).deliver
      flash[:success] = "Your invitation was sent."
      redirect_to new_invitation_path
    else
      flash.now[:danger] = "Please fix the following errors."
      render :new
    end

  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
  end
end