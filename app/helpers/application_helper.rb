module ApplicationHelper
  def options_for_video_reviews(selected=nil)
    options_for_select((1..5).map { |num| [pluralize(num, "Star"), num] }, selected)
  end

  def options_for_ratings(field)
    options_for_select((10..50).map { |num| num / 10.0 }, field)
  end
end
