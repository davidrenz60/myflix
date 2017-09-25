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
    review = Review.find_by(user: user, video: video)
    review.rating if review
  end

  def category_name
    category.name
  end
end