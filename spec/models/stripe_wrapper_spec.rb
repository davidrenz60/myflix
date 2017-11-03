require "spec_helper"

describe StripeWrapper do
  describe ".create" do
    let(:token) do
      Stripe::Token.create(
        card: {
          number: card_number,
          exp_month: 10,
          exp_year: 2018,
          cvc: "314"
        }
      ).id
    end

    context "with valid card number", :vcr do
      let(:card_number) { 4242424242424242 }
      let(:charge) { StripeWrapper::Charge.create(amount: 999, source: token) }

      it "charges the card" do
        expect(charge).to be_successful
      end
    end

    context "with invalid card number", :vcr do
      let(:card_number) { 4000000000000002 }
      let(:charge) { StripeWrapper::Charge.create(amount: 999, source: token) }

      it "does not charge the card" do
        expect(charge).not_to be_successful
      end
      it "contains an error message" do
        expect(charge.error_message).to eq("Your card was declined.")
      end
    end
  end
end
