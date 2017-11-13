require "spec_helper"

describe "deactivate user account on failed charge" do
  let(:event_data) {
    {
      "id"=> "evt_1BNlL1ACRY9yqAzKnqN8pjHq",
      "object"=> "event",
      "api_version"=> "2017-08-15",
      "created"=> 1510592591,
      "data"=> {
        "object"=> {
          "id"=> "ch_1BNlL0ACRY9yqAzKXiFg6AF7",
          "object"=> "charge",
          "amount"=> 999,
          "amount_refunded"=> 0,
          "application"=> nil,
          "application_fee"=> nil,
          "balance_transaction"=> nil,
          "captured"=> false,
          "created"=> 1510592590,
          "currency"=> "usd",
          "customer"=> "cus_BlGUUX8lFfVLkb",
          "description"=> "",
          "destination"=> nil,
          "dispute"=> nil,
          "failure_code"=> "card_declined",
          "failure_message"=> "Your card was declined.",
          "fraud_details"=> {
          },
          "invoice"=> nil,
          "livemode"=> false,
          "metadata"=> {
          },
          "on_behalf_of"=> nil,
          "order"=> nil,
          "outcome"=> {
            "network_status"=> "declined_by_network",
            "reason"=> "generic_decline",
            "risk_level"=> "normal",
            "seller_message"=> "The bank did not return any further details with this decline.",
            "type"=> "issuer_declined"
          },
          "paid"=> false,
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "refunded"=> false,
          "refunds"=> {
            "object"=> "list",
            "data"=> [
            ],
            "has_more"=> false,
            "total_count"=> 0,
            "url"=> "/v1/charges/ch_1BNlL0ACRY9yqAzKXiFg6AF7/refunds"
          },
          "review"=> nil,
          "shipping"=> nil,
          "source"=> {
            "id"=> "card_1BNlKnACRY9yqAzKvretC0a5",
            "object"=> "card",
            "address_city"=> nil,
            "address_country"=> nil,
            "address_line1"=> nil,
            "address_line1_check"=> nil,
            "address_line2"=> nil,
            "address_state"=> nil,
            "address_zip"=> nil,
            "address_zip_check"=> nil,
            "brand"=> "Visa",
            "country"=> "US",
            "customer"=> "cus_BlGUUX8lFfVLkb",
            "cvc_check"=> "pass",
            "dynamic_last4"=> nil,
            "exp_month"=> 1,
            "exp_year"=> 2019,
            "fingerprint"=> "3I2REysCOS7R9AJ1",
            "funding"=> "credit",
            "last4"=> "0341",
            "metadata"=> {
            },
            "name"=> nil,
            "tokenization_method"=> nil
          },
          "source_transfer"=> nil,
          "statement_descriptor"=> nil,
          "status"=> "failed",
          "transfer_group"=> nil
        }
      },
      "livemode"=> false,
      "pending_webhooks"=> 1,
      "request"=> {
        "id"=> "req_XSMNY7WPYBvJUO",
        "idempotency_key"=> nil
      },
      "type"=> "charge.failed"
    }
  }

  let!(:alice) { Fabricate(:user, customer_token: "cus_BlGUUX8lFfVLkb", active: true) }

  before { post "/stripe_events", event_data }

  it "deactivates the associated user's account from the stripe webhook data", :vcr do
    expect(alice.reload).not_to be_active
  end

  it "sends an email to the user", :vcr do
     expect(ActionMailer::Base.deliveries.count).to eq(1)
  end
end