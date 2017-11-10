require "spec_helper"

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      card: {
        number: 4242424242424242,
        exp_month: 10,
        exp_year: 2018,
        cvc: "314"
      }
    ).id
  end

  let(:invalid_token) do
    Stripe::Token.create(
      card: {
        number: 4000000000000002,
        exp_month: 10,
        exp_year: 2018,
        cvc: "314"
      }
    ).id
  end

  describe StripeWrapper::Charge do
    describe ".create" do
      context "with valid card number", :vcr do
        let(:charge) { StripeWrapper::Charge.create(amount: 999, source: valid_token) }

        it "charges the card" do
          expect(charge).to be_successful
        end
      end

      context "with invalid card number", :vcr do
        let(:charge) { StripeWrapper::Charge.create(amount: 999, source: invalid_token) }

        it "does not charge the card" do
          expect(charge).not_to be_successful
        end
        it "contains an error message" do
          expect(charge.error_message).to eq("Your card was declined.")
        end
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      let(:alice) { Fabricate("user") }

      context "with valid credit card", :vcr do
        let(:customer) { StripeWrapper::Customer.create(description: "new customer", source: valid_token, user: alice) }

        it "creates a customer with a valid credit card" do
          expect(customer).to be_successful
        end
      end

      context "with invalid credit card", :vcr do
        let(:customer) { StripeWrapper::Customer.create(description: "new customer", source: invalid_token, user: alice) }

        it "does not create a customer" do
          expect(customer).not_to be_successful
        end

        it "contains an error message" do
          expect(customer.error_message).to eq("Your card was declined.")
        end
      end
    end
  end
end