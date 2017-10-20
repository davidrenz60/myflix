module ApplicationHelper
  def display_rating(rating)
    rating ? rating.to_s + "/5.0" : "No reviews yet"
  end

  def options_for_video_reviews(selected=nil)
    options_for_select((1..5).map { |num| [pluralize(num, "Star"), num] }, selected)
  end
end
