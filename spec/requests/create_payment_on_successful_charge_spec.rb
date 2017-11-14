require "spec_helper"

describe "Create a payment with a successful charge" do
  let(:event_data) {
    {
      "id"=> "evt_1BN0r3ACRY9yqAzK4VaA68Bg",
      "object"=> "event",
      "api_version"=> "2017-08-15",
      "created"=> 1510413909,
      "data"=> {
        "object"=> {
          "id"=> "ch_1BN0r2ACRY9yqAzKWfDLjl49",
          "object"=> "charge",
          "amount"=> 999,
          "amount_refunded"=> 0,
          "application"=> nil,
          "application_fee"=> nil,
          "balance_transaction"=> "txn_1BN0r2ACRY9yqAzKrUzrDTGT",
          "captured"=> true,
          "created"=> 1510413908,
          "currency"=> "usd",
          "customer"=> "cus_BkVs0IRprV5gMh",
          "description"=> nil,
          "destination"=> nil,
          "dispute"=> nil,
          "failure_code"=> nil,
          "failure_message"=> nil,
          "fraud_details"=> {
          },
          "invoice"=> "in_1BN0r2ACRY9yqAzK7pKdZa6Y",
          "livemode"=> false,
          "metadata"=> {
          },
          "on_behalf_of"=> nil,
          "order"=> nil,
          "outcome"=> {
            "network_status"=> "approved_by_network",
            "reason"=> nil,
            "risk_level"=> "normal",
            "seller_message"=> "Payment complete.",
            "type"=> "authorized"
          },
          "paid"=> true,
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "refunded"=> false,
          "refunds"=> {
            "object"=> "list",
            "data"=> [

            ],
            "has_more"=> false,
            "total_count"=> 0,
            "url"=> "/v1/charges/ch_1BN0r2ACRY9yqAzKWfDLjl49/refunds"
          },
          "review"=> nil,
          "shipping"=> nil,
          "source"=> {
            "id"=> "card_1BN0r1ACRY9yqAzKmYIfzjUR",
            "object"=> "card",
            "address_city"=> nil,
            "address_country"=> nil,
            "address_line1"=> nil,
            "address_line1_check"=> nil,
            "address_line2"=> nil,
            "address_state"=> nil,
            "address_zip"=> "42424",
            "address_zip_check"=> "pass",
            "brand"=> "Visa",
            "country"=> "US",
            "customer"=> "cus_BkVs0IRprV5gMh",
            "cvc_check"=> "pass",
            "dynamic_last4"=> nil,
            "exp_month"=> 4,
            "exp_year"=> 2024,
            "fingerprint"=> "q2TyZusZTFXy5XkY",
            "funding"=> "credit",
            "last4"=> "4242",
            "metadata"=> {
            },
            "name"=> nil,
            "tokenization_method"=> nil
          },
          "source_transfer"=> nil,
          "statement_descriptor"=> nil,
          "status"=> "succeeded",
          "transfer_group"=> nil
        }
      },
      "livemode"=> false,
      "pending_webhooks"=> 1,
      "request"=> {
        "id"=> "req_NWibsb0n1zHzmU",
        "idempotency_key"=> nil
      },
      "type"=> "charge.succeeded"
    }
  }

  let!(:alice) { Fabricate(:user, customer_token: "cus_BkVs0IRprV5gMh") }

  before { post "/stripe_events", event_data }

  it "creates a payment with the stripe webhook when a successful charge is made", :vcr do
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user", :vcr do
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the amount", :vcr do
    expect(Payment.first.amount).to eq(999)
  end

  it "creates a payment with the reference id", :vcr do
    expect(Payment.first.reference_id).to eq("ch_1BN0r2ACRY9yqAzKWfDLjl49")
  end
end