require "spec_helper"

describe UsersController do
  describe "GET new" do
    it "sets @user to a new user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it "redirects to home page if authenticated" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "GET new_with_invitation" do
    let(:invitation) { Fabricate(:invitation) }

    it "renders the new template" do
      get :new_with_invitation, token: invitation.token
      expect(response).to render_template(:new)
    end

    it "sets @user with recipient's email address" do
      get :new_with_invitation, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "sets @invitation_token" do
      get :new_with_invitation, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects to the invalid token page if token is expired" do
      get :new_with_invitation, token: "1234"
      expect(response).to redirect_to invalid_token_path
    end
  end

  describe "GET show" do
    context "with authenticated user" do
      let(:user) { Fabricate(:user) }

      it "sets @user" do
        set_current_user
        get :show, id: user.id
        expect(assigns(:user)).to eq(user)
      end
    end

    it_behaves_like "require sign in" do
      let(:action) { get :show, id: Fabricate(:user).id }
    end
  end

  describe "POST create" do
    context "with valid input" do
      after { ActionMailer::Base.deliveries.clear }

      it "creates a new user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "redirects to the sign in page" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end

      context "with invitation" do
        let(:alice) { Fabricate(:user) }
        let(:invitation) { Fabricate(:invitation, inviter: alice) }

        before do
          post :create, user: { email: "jon@test.com", password: "password", full_name: "Jon Doe" }, invitation_token: invitation.token
        end

        it "makes the new user follow the inviter" do
          jon = User.find_by(email: "jon@test.com")
          expect(jon.follows?(alice)).to eq(true)
        end

        it "makes the inviter follow the new user" do
          jon = User.find_by(email: "jon@test.com")
          expect(alice.follows?(jon)).to eq(true)
        end

        it "expires the invitation token" do
          expect(Invitation.first.token).to be_nil
        end
      end
    end

    context "with invalid input" do
      before do
        post :create, user: { password: "1234", full_name: "Joe Smith" }
      end

      it "does not create a new user" do
        expect(User.count).to eq(0)
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end

      it "sets @user" do
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    context "sending email" do
      after { ActionMailer::Base.deliveries.clear }

      it "sends to the right user with valid input" do
        post :create, user: { email: "joe@example.com", password: "password", full_name: "Joe Smith" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end

      it "sends an email with the user's name with valid input" do
        post :create, user: { email: "joe@example.com", password: "password", full_name: "Joe Smith" }
        expect(ActionMailer::Base.deliveries.last.body).to include("Joe Smith")
      end

      it "does not send an email with invalid input" do
        post :create, user: { password: "password", full_name: "Joe Smith" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
