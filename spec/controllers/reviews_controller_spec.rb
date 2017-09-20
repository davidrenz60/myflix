require 'spec_helper'

describe ReviewsController do
  let(:video) { Fabricate(:video) }

  describe 'POST create' do
    context 'with unauthenticated user' do
      it 'redirects to the sign in path' do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end

    context 'with authenticated user' do
      let(:user) { Fabricate(:user) }
      before {session[:user_id] = user.id }

      context 'with valid input' do
        before do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
        end

        it 'creates a review' do
          expect(Review.count).to eq(1)
        end

        it 'associates the review with the video' do
          expect(Review.first.video).to eq(video)
        end

        it "associates the review with the current user" do
          expect(Review.first.user).to eq(user)
        end

        it 'redirects to the video path' do
          expect(response).to redirect_to video_path(video)
        end

        it 'sets a flash message' do
          expect(flash[:success]).not_to be_nil
        end
      end

      context 'with invalid input' do
        it 'does not create a review' do
          post :create, video_id: video.id, review: { rating: 3 }
          expect(Review.count).to eq(0)
        end

        it 'renders the videos/show template' do
          post :create, video_id: video.id, review: { rating: 3 }
          expect(response).to render_template('videos/show')
        end

        it 'sets @reviews' do
          review = Fabricate(:review, video: video)
          post :create, video_id: video.id, review: { rating: 3 }
          expect(assigns(:reviews)).to eq(video.reviews)
        end

        it 'sets @video' do
          post :create, video_id: video.id, review: { rating: 3 }
          expect(assigns(:video)).to eq(video)
        end
      end
    end
  end
end
