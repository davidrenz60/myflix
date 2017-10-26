require "spec_helper"

describe InvitationsController do
  describe "GET new" do
    it "sets @invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_a_new(Invitation)
    end

    it_behaves_like "require sign in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    context "with authenticated user" do
      let(:alice) { Fabricate(:user) }

      context "with valid inputs" do
        before do
          set_current_user(alice)
          post :create, invitation: { recipient_name: "Bob Smith", recipient_email: "bob@test.com", message: "Sign up!" }
        end

        after { ActionMailer::Base.deliveries.clear }

        it "creates a new invitation" do
          expect(Invitation.count).to eq(1)
        end

        it "sets the inviter to the current user" do
          expect(Invitation.first.inviter).to eq(alice)
        end

        it "sends an email to the recipient" do
          expect(ActionMailer::Base.deliveries.last.to).to eq(["bob@test.com"])
        end

        it "sets a flash message" do
          expect(flash[:success]).to eq("Your invitation was sent.")
        end

        it "redirects to the new invitation page" do
          expect(response).to redirect_to new_invitation_path
        end
      end

      context "with invalid inputs" do
        before do
          set_current_user(alice)
          post :create, invitation: { recipient_name: "Bob Smith", message: "Sign up!" }
        end

        it "does not create a new invitation" do
          expect(Invitation.count).to eq(0)
        end

        it "does not send an email" do
          expect(ActionMailer::Base.deliveries).to be_empty
        end

        it "sets a flash message" do
          expect(flash.now[:danger]).to eq("Please fix the following errors.")
        end

        it "renders the new template" do
          expect(response).to render_template(:new)
        end
      end
    end

    it_behaves_like "require sign in" do
      let(:action) { post :create }
    end
  end
end