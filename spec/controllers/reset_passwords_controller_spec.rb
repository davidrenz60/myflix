require "spec_helper"

describe ResetPasswordsController do
  describe "GET show" do
    it "renders the show template if the token is valid" do
      alice = Fabricate(:user)
      alice.update_column(:token, "1234")
      get :show, id: "1234"
      expect(response).to render_template(:show)
    end

    it "redirects to the expired token page if the token is invalid" do
      get :show, id: "1234"
      expect(response).to redirect_to invalid_token_path
    end
  end
end