class Invitation < ActiveRecord::Base
  include Tokenable

  belongs_to :inviter, class_name: "User", foreign_key: "inviter_id"
  validates_presence_of :recipient_email, :recipient_name, :message
end