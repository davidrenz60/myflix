require "spec_helper"

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "require sign in" do
      let(:action) { get :new }
    end

    it "sets @video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_a_new(Video)
    end

    it "redirects to the sign in page for a regular user" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end

    it "sets a flash message for a regular user" do
      set_current_user
      get :new
      expect(flash[:danger]).not_to be_nil
    end
  end
end