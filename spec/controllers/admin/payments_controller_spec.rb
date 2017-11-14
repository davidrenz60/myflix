require "spec_helper"

describe Admin::PaymentsController do
  describe "GET index" do
    it_behaves_like "require admin" do
      let(:action) { get :index }
    end

    it "sets @payments" do
      payment = Payment.create
      set_current_admin
      get :index
      expect(assigns(:payments)).to eq([payment])
    end
  end
end