class UserRegistration
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def create(stripe_token, invitation_token)
    if @user.valid?
      customer = StripeWrapper::Customer.create(
        description: "sign up charge for myflix",
        user: @user,
        source: stripe_token
      )

      if customer.successful?
        @status = :success
        @user.save
        handle_invitations(invitation_token)
        UserMailer.perform_async(@user.id)
        self
      else
        @status = :error
        @error_message = customer.error_message
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