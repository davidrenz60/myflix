require "spec_helper"

describe ResetPasswordsController do
  describe "GET show" do
    let(:alice) { Fabricate(:user) }

    it "sets @token" do
      alice.update_column(:token, "1234")
      get :show, id: "1234"
      expect(assigns(:token)).to eq("1234")
    end

    it "renders the show template if the token is valid" do
      alice.update_column(:token, "1234")
      get :show, id: "1234"
      expect(response).to render_template(:show)
    end

    it "redirects to the expired token page if the token is invalid" do
      get :show, id: "1234"
      expect(response).to redirect_to invalid_token_path
    end
  end

  describe "POST create" do
    context "with a valid token" do
      context "with valid password" do
        let(:alice) { Fabricate(:user, password: "old_password") }
        let(:token) { "1234" }

        before do
          alice.update_column(:token, token)
          post :create, token: token, password: "new_password"
        end

        it "sets a new password" do
          expect(alice.reload.authenticate("new_password")).to eq(alice)
        end

        it "clears the user's token" do
          expect(alice.reload.token).to be_nil
        end

        it "sets a flash message" do
          expect(flash[:success]).to eq("Password changed. Please log in.")
        end

        it "redirects to the sign in page" do
          expect(response).to redirect_to sign_in_path
        end
      end

      context "with an invalid password" do
        let(:alice) { Fabricate(:user, password: "old_password") }
        let(:token) { "1234" }

        before do
          alice.update_column(:token, token)
          post :create, token: token, password: ""
        end

        it "does not update the user's password" do
          expect(alice.reload.authenticate("old_password")).to eq(alice)
        end

        it "does not update the user's token" do
          expect(alice.reload.token).to eq(token)
        end

        it "sets a flash message" do
          expect(flash[:danger]).to eq("There was a problem updating your password.")
        end

        it "redirects to the reset password page" do
          expect(response).to redirect_to reset_password_path(alice.token)
        end
      end
    end

    context "with an invalid token" do
      let(:alice) { Fabricate(:user, password: "old_password") }

      it "redirects to the invalid token path with a different token" do
        post :create, token: "1234", password: "new_password"
        expect(response).to redirect_to invalid_token_path
      end

      it "redirects to the invalid token path with a nil token" do
        post :create, token: alice.token, password: "new_password"
        expect(response).to redirect_to invalid_token_path
      end
    end
  end
end