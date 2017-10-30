require "spec_helper"

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "require sign in" do
      let(:action) { get :new }
    end

    it_behaves_like "require admin" do
      let(:action) { post :create }
    end

    it "sets @video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_a_new(Video)
    end
  end

  describe "POST create" do
    it_behaves_like "require sign in" do
      let(:action) { post :create }
    end

    it_behaves_like "require admin" do
      let(:action) { post :create }
    end

    context "with valid input" do
      before do
        set_current_admin
        post :create, video: Fabricate.attributes_for(:video)
      end

      it "creates a new video" do
        expect(Video.count).to eq(1)
      end

      it "sets a flash message" do
        expect(flash[:success]).not_to be_nil
      end

      it "redirects to the admin new video page" do
        expect(response).to redirect_to new_admin_video_path
      end

    end
    context "with invalid input" do
      before do
        set_current_admin
        post :create, video: { title: "Monk" }
      end

      it "does not create a new video" do
        expect(Video.count).to eq(0)
      end

      it "sets @video" do
        expect(assigns(:video)).to be_present
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end
    end
  end
end