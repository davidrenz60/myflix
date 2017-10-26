class InvitationMailer
  include Sidekiq::Worker

  def perform(id)
    invitation = Invitation.find(id)
    AppMailer.send_invitation(invitation).deliver
  end
end