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

  describe 'POST create' do
    it 'creates a new queue item for signed in user' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it 'creates a new queue item with the current user' do
      alice = Fabricate(:user)
      video = Fabricate(:video)
      session[:user_id] = alice.id
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(alice)
    end

    it 'creates a new queue item with the associated video' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video, title: "Monk")
      post :create, video_id: video.id
      expect(QueueItem.first.video_title).to eq("Monk")
    end

    it 'adds the video to the end of the queue' do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      monk = Fabricate(:video, title: "Monk")
      south_park = Fabricate(:video, title: "South Park")
      Fabricate(:queue_item, video: monk, user: alice)

      post :create, video_id: south_park.id
      queue_item = QueueItem.find_by(user: alice, video: south_park)

      expect(queue_item.position).to eq(2)
    end

    it 'will not add the item if the video is already in the queue for the user' do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      video = Fabricate(:video)
      Fabricate(:queue_item, video: video, user: alice)

      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it 'redirects to the my queue page for signed in user' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video, title: "Monk")
      post :create, video_id: video.id
      expect(response).to redirect_to(my_queue_path)
    end

    it 'redirects to the sign in page for unauthenticated user' do
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to(sign_in_path)
    end
  end

  describe "DELETE destroy" do
    it 'removes the item from the queue for signed in user' do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      queue_item = Fabricate(:queue_item, user: alice)
      post :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it 'does not delete the item if it is not in the queue of the current user' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      session[:user_id] = alice.id
      queue_item = Fabricate(:queue_item, user: bob)
      post :destroy, id: queue_item.id
      expect(QueueItem.count).to be(1)
    end

    it 'redirects to the my queue page' do
      session[:user_id] = Fabricate(:user)
      queue_item = Fabricate(:queue_item)
      post :destroy, id: queue_item.id
    end

    it 'redirects to the sign in page for unauthenticated user' do
      queue_item1 = Fabricate(:queue_item)
      post :destroy, id: queue_item1.id
    end
  end
end
