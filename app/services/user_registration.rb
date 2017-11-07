class UserRegistration
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def register(stripe_token, invitation_token)
    if @user.valid?
      charge = StripeWrapper::Charge.create(
        amount: 999,
        description: "sign up charge for #{@user.full_name}",
        source: stripe_token
      )

      if charge.successful?
        @status = :success
        @user.save
        handle_invitations(invitation_token)
        UserMailer.perform_async(@user.id)
        self
      else
        @status = :error
        @error_message = charge.error_message
        self
      end
    else
      @status = :error
      @error_message = "Invalid user information. Please fix the following errors."
      self
    end
  end

  def successful?
    @status == :success
  end

  private

  def handle_invitations(invitation_token)
    if invitation_token.present?
      invitation = Invitation.find_by(token: invitation_token)
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end
end