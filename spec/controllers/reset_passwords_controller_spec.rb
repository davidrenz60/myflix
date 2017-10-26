require "spec_helper"

describe ResetPasswordsController do
  describe "GET show" do
    let(:alice) { Fabricate(:user, token: "1234") }

    it "sets @token" do
      get :show, id: alice.token
      expect(assigns(:token)).to eq(alice.token)
    end

    it "renders the show template if the token is valid" do
      get :show, id: alice.token
      expect(response).to render_template(:show)
    end

    it "redirects to the expired token page if the token is invalid" do
      get :show, id: alice.token + "123"
      expect(response).to redirect_to invalid_token_path
    end
  end

  describe "POST create" do
    context "with a valid token" do
      context "with valid password" do
        let(:alice) { Fabricate(:user, password: "old_password") }

        before do
          alice.update_column(:token, "1234")
          post :create, token: alice.token, password: "new_password"
        end

        it "sets a new password" do
          expect(alice.reload.authenticate("new_password")).to eq(alice)
        end

        it "regenerates the user's token" do
          expect(alice.reload.token).not_to eq("1234")
        end

        it "sets a flash message" do
          expect(flash[:success]).to eq("Password changed. Please log in.")
        end

        it "redirects to the sign in page" do
          expect(response).to redirect_to sign_in_path
        end
      end
    end

    context "with an invalid token" do
      let(:alice) { Fabricate(:user, password: "old_password", token: "1234") }

      it "redirects to the invalid token path with a different token" do
        post :create, token: "abcd", password: "new_password"
        expect(response).to redirect_to invalid_token_path
      end
    end
  end
end