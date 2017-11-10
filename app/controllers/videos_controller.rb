class VideosController < ApplicationController
  before_action :require_user

  def index
    @categories = Category.all.order(:name)
  end

  def show
    @video = Video.find(params[:id]).decorate
    @reviews = @video.reviews
    @review = Review.new
  end

  def search
    @videos = Video.search_by_title(params[:search])
  end
end