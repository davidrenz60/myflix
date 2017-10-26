class User < ActiveRecord::Base
  has_secure_password validations: false
  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  has_many :followers, through: :leading_relationships
  has_many :leading_relationships, class_name: "Relationship", foreign_key: "leader_id"

  has_many :leaders, through: :following_relationships
  has_many :following_relationships, class_name: "Relationship", foreign_key: "follower_id"

  has_many :reviews, -> { order("created_at DESC") }
  has_many :queue_items, -> { order(:position) }

  before_create :generate_token

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, idx|
      queue_item.update_attributes(position: idx + 1)
    end
  end

  def video_in_queue?(video)
    queue_items.map(&:video).include?(video)
  end

  def follow(another_user)
    following_relationships.create(leader: another_user) if can_follow?(another_user)
  end

  def follows?(other_user)
    leaders.include?(other_user)
  end

  def can_follow?(another_user)
    !(self == another_user || self.follows?(another_user))
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end
