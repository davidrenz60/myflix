class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_presence_of :content, :rating
  validates :rating, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 5
  }
end