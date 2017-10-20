require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    context 'with authenticated user' do
      let(:video) { Fabricate(:video) }
      before { set_current_user }

      it 'sets @video' do
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it 'sets @reviews' do
        review1 = Fabricate(:review, video: video)
        review2 = Fabricate(:review, video: video)
        get :show, id: video.id
        expect(assigns(:reviews)).to match_array([review1, review2])
      end

      it 'sets @review' do
        get :show, id: video.id
        expect(assigns(:review)).to be_a_new(Review)
      end
    end

    it_behaves_like "require sign in" do
      let(:action) { get :show, id: 1 }
    end
  end

  describe 'GET search' do
    let(:video) { Fabricate(:video) }

    it 'sets @videos for authenticated user' do
      set_current_user
      get :search, search: video.title
      expect(assigns(:videos)).to include(video)
    end

    it_behaves_like "require sign in" do
      let(:action) { get :search, search: video.title }
    end
  end
end
