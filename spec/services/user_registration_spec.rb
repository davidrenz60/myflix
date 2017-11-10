require "spec_helper"

describe UserRegistration do
  describe "#register" do
    context "with valid information and no invitation" do
      let(:customer) { double("customer", successful?: true) }

      before do
        expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
        UserRegistration.new(Fabricate.build(:user, email: "joe@example.com", full_name: "Joe Smith")).create("stripe_token", nil)
      end

      it "creates a new user" do
        expect(User.count).to eq(1)
      end

      it "sends an email to the user" do
       expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end

      it "sends an email with the user's name" do
        expect(ActionMailer::Base.deliveries.last.body).to include("Joe Smith")
      end
    end

    context "with valid information and invitation" do
      let(:alice) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com") }
      let(:customer) { double("customer", successful?: true) }

      before do
        expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
        UserRegistration.new(Fabricate.build(:user, email: "joe@example.com", full_name: "Joe Smith")).create("stripe_token", invitation.token)
      end

      it "makes the new user follow the inviter" do
        joe = User.find_by(email: "joe@example.com")
        expect(joe.follows?(alice)).to eq(true)
      end

      it "makes the inviter follow the new user" do
        jon = User.find_by(email: "joe@example.com")
        expect(alice.follows?(jon)).to eq(true)
      end

      it "expires the invitation token" do
        expect(Invitation.first.token).to be_nil
      end
    end

    context "with valid user info and invalid credit card" do
      let(:customer) { double("customer", successful?: false, error_message: "Error message") }

      before do
        expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
        UserRegistration.new(Fabricate.build(:user)).create("stripe_token", nil)
      end

      it "does not create a new user" do
        expect(User.count).to eq(0)
      end

      it "does not send an email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "with invalid user and valid credit card" do
      before do
        UserRegistration.new(User.new(email: "joe@example.com")).create("stripe_token", nil)
      end

      it "does not create a new user" do
          expect(User.count).to eq(0)
        end

      it "does not create a customer" do
        expect(StripeWrapper::Customer).not_to receive(:create)
      end

      it "does not send an email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end