class Video < ActiveRecord::Base
  belongs_to :category

  validates_presence_of :title, :description

  def self.search_by_title(title)
    return [] if title.blank?
    results = where("lower(title) LIKE ?", "%#{title.downcase}%").order("created_at DESC")
  end
end