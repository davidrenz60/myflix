class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_presence_of :user, :video
  validates_numericality_of :position, only_integer: true
  validates :video, uniqueness: { scope: :user }

  delegate :category, to: :video
  delegate :title, to: :video, prefix: "video"

  def video_title
    video.title
  end

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update_attribute(:rating, new_rating)
    else
      return if new_rating.blank?
      Review.new(rating: new_rating, user: user, video: video).save(validate: false)
    end
  end

  def category_name
    category.name
  end

  private

  def review
    @review ||= Review.find_by(user: user, video: video)
  end
end