class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order(created_at: :desc) }

  validates_presence_of :title, :description

  def self.search_by_title(title)
    return [] if title.blank?
    results = where("lower(title) LIKE ?", "%#{title.downcase}%").order("created_at DESC")
  end

  def average_rating
    average = Review.where(video_id: id).average(:rating)
    average.round(1) if average
  end
end