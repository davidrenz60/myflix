module StripeWrapper
  class Charge
    attr_reader :response, :status

    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options={})
      begin
        response = Stripe::Charge.create(
          amount: options[:amount],
          description: options[:description],
          source: options[:source],
          currency: "usd"
        )

        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end

    def successful?
      status == :success
    end

    def error_message
      response.message
    end
  end

  class Customer < Charge
    def self.create(options={})
      begin
        response = Stripe::Customer.create(
          description: options[:description],
          source: options[:source],
          email: options[:user].email,
          plan: "base"
        )
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end

    def id
      response.id
    end
  end
end
