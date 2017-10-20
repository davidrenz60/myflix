require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do
    it_behaves_like "require sign in" do
      let(:action) { post :create, video_id: 1 }
    end

    context 'with authenticated user' do
      let(:video) { Fabricate(:video) }
      let(:user) { Fabricate(:user) }

      context 'with valid input' do
        it 'creates a review' do
          set_current_user
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
          expect(Review.count).to eq(1)
        end

        it 'associates the review with the video' do
          set_current_user
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
          expect(Review.first.video).to eq(video)
        end

        it "associates the review with the current user" do
          set_current_user(user)
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
          expect(Review.first.user).to eq(user)
        end

        it 'redirects to the video path' do
          set_current_user
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
          expect(response).to redirect_to video_path(video)
        end

        it 'sets a flash message' do
          set_current_user
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
          expect(flash[:success]).not_to be_nil
        end
      end

      context 'with invalid input' do
        it 'does not create a review' do
          set_current_user
          post :create, video_id: video.id, review: { rating: 3 }
          expect(Review.count).to eq(0)
        end

        it 'renders the videos/show template' do
          set_current_user
          post :create, video_id: video.id, review: { rating: 3 }
          expect(response).to render_template('videos/show')
        end

        it 'sets @reviews' do
          set_current_user
          review = Fabricate(:review, video: video)
          post :create, video_id: video.id, review: { rating: 3 }
          expect(assigns(:reviews)).to eq(video.reviews)
        end

        it 'sets @video' do
          set_current_user
          post :create, video_id: video.id, review: { rating: 3 }
          expect(assigns(:video)).to eq(video)
        end
      end
    end
  end
end
