require "spec_helper"

describe ForgotPasswordsController do
  describe "POST create" do
    let(:user) { Fabricate(:user) }

    context "with valid email" do
      before { post :create, email: user.email }
      after { ActionMailer::Base.deliveries.clear }

      it "sends an email to the proper email address" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
      end

      it "generates a token for the user" do
        expect(user.reload.token).to be_present
      end

      it "redirects to the forgot password confirmation page" do
        expect(response).to redirect_to forgot_password_confirmation_path
      end
    end

    context "with empty email field" do
      before { post :create, email: "" }

      it "redirects to the forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end

      it "sets a flash message" do
        expect(flash[:danger]).to eq("Email cannot be blank.")
      end
    end

    context "with invalid email" do
      before { post :create, email: "dave@test.com" }

      it "redirects to the forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end

      it "sets a flash message" do
        expect(flash[:danger]).to eq("Email address not found.")
      end
    end
  end
end