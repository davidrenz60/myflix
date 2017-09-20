require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    it 'sets @queue_tems to the queue items of the signed in user' do
      alice = Fabricate(:user)
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      session[:user_id] = alice.id
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it 'redirects to the sign in page for unauthenticated user' do
      get :index
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
