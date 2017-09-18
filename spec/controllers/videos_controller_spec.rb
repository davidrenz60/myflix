require 'spec_helper'

describe VideosController do
  let(:video) { Fabricate(:video) }
  let(:user) { Fabricate(:user) }

  describe 'GET show' do
    it 'sets @video for authenticated user' do
      session[:user_id] = user.id
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it 'sets @reviews for authenticated user' do
      session[:user_id] = user.id
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it 'redirects to the sign in page for unauthenticated user' do
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe 'GET search' do
    it 'sets @videos for authenticated user' do
      session[:user_id] = user.id
      get :search, search: video.title
      expect(assigns(:videos)).to include(video)
    end

    it 'redirects to the sign in page for unauthenticated user' do
      get :search, search: video.title
      expect(response).to redirect_to sign_in_path
    end
  end
end
