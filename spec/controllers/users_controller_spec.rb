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
    context "successful user sign up" do
      let(:registration) { double("registration", successful?: true) }

      before do
        expect_any_instance_of(UserRegistration).to receive(:create).and_return(registration)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end

      it "sets a flash message" do
        expect(flash[:success]).not_to be_nil
      end
    end

    context "failed user sign up" do
      let(:registration) { double("registration", successful?: false, error_message: "There were errors.") }

      before do
        expect_any_instance_of(UserRegistration).to receive(:create).and_return(registration)
        post :create, user: { email: "joe@test.com", password: "password" }
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end

      it "sets @user" do
        expect(assigns(:user)).to be_a_new(User)
      end

      it "sets a flash message" do
        expect(flash[:danger]).not_to be_nil
      end
    end
  end
end
