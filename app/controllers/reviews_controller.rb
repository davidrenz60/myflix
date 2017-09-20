class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.build(review_params)
    @review.user = current_user

    # TODO: add errors to template

    if @review.save
      flash[:success] = "Your review was submitted."
      redirect_to video_path(@video)
    else
      @reviews = @video.reviews.reload
      render 'videos/show'
    end
  end

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end