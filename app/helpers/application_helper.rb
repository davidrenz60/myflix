module ApplicationHelper
  def display_rating(rating)
    rating ? rating.to_s + "/5.0" : "No reviews yet"
  end
end
