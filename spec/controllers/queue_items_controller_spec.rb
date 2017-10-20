require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    let(:alice) { Fabricate(:user) }
    let(:queue_item1) { Fabricate(:queue_item, user: alice) }
    let(:queue_item2) { Fabricate(:queue_item, user: alice) }

    it 'sets @queue_tems to the queue items of the signed in user' do
      set_current_user(alice)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it_behaves_like "require sign in" do
      let(:action) { get :index }
    end
  end

  describe 'POST create' do
    let(:alice) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    it 'creates a new queue item for signed in user' do
      set_current_user
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it 'creates a new queue item with the current user' do
      set_current_user(alice)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(alice)
    end

    it 'creates a new queue item with the associated video' do
      set_current_user
      monk = Fabricate(:video, title: "Monk")
      post :create, video_id: monk.id
      expect(QueueItem.first.video_title).to eq("Monk")
    end

    it 'adds the video to the end of the queue' do
      set_current_user(alice)
      monk = Fabricate(:video, title: "Monk")
      south_park = Fabricate(:video, title: "South Park")
      Fabricate(:queue_item, video: monk, user: alice)

      post :create, video_id: south_park.id
      set_current_user(alice)
      queue_item = QueueItem.find_by(user: alice, video: south_park)
      expect(queue_item.position).to eq(2)
    end

    it 'will not add the item if the video is already in the queue for the user' do
      set_current_user(alice)
      Fabricate(:queue_item, video: video, user: alice)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it 'redirects to the my queue page for signed in user' do
      set_current_user
      post :create, video_id: video.id
      expect(response).to redirect_to(my_queue_path)
    end

    it_behaves_like "require sign in" do
      let(:action) { post :create }
    end
  end

  describe "DELETE destroy" do
    let(:alice) { Fabricate(:user) }

    it 'removes the item from the queue for signed in user' do
      set_current_user(alice)
      queue_item = Fabricate(:queue_item, user: alice)
      post :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it 'does not delete the item if it is not in the queue of the current user' do
      set_current_user
      bob = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: bob)
      post :destroy, id: queue_item.id
      expect(QueueItem.count).to be(1)
    end

    it 'normalizes the queue_item positions' do
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
      queue_item2 = Fabricate(:queue_item, user: alice, position: 2)
      post :destroy, id: queue_item1.id
      expect(QueueItem.first.position).to eq(1)
    end

    it 'redirects to the my queue page' do
      set_current_user
      queue_item = Fabricate(:queue_item)
      post :destroy, id: queue_item.id
    end

    it_behaves_like "require sign in" do
      let(:action) do
        post :destroy, id: 1
      end
    end
  end

  describe 'POST update_queue' do
    context 'with valid input' do
      let(:alice) { Fabricate(:user) }
      let(:queue_item1) { Fabricate(:queue_item, user: alice, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 2) }

      it 'redirects to the my qeueue page' do
        set_current_user
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 2 }, { id: queue_item2.id, position: 1 }]
        expect(response).to redirect_to my_queue_path
      end

      it 'reorders the queue items' do
        set_current_user(alice)
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 2 }, { id: queue_item2.id, position: 1 }]
        expect(alice.queue_items).to eq([queue_item2, queue_item1])
      end

      it 'normalizes the position numbers of the queue items' do
        set_current_user(alice)
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 6 }, { id: queue_item2.id, position: 2 }]
        expect(alice.queue_items.map(&:position)).to eq([1, 2])
      end
    end

    context 'with invalid input' do
      let(:alice) { Fabricate(:user) }
      let(:queue_item1) { Fabricate(:queue_item, user: alice, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 2) }

      it 'redirects to the my queue page' do
        set_current_user
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 3.4 }, { id: queue_item2.id, position: 2 }]
        expect(response).to redirect_to my_queue_path
      end

      it 'sets a flash error message' do
        set_current_user(alice)
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 3.4 }, { id: queue_item2.id, position: 2 }]
        expect(flash[:danger]).not_to be_nil
      end

      it 'does not change the queue items' do
        set_current_user
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 3 }, { id: queue_item2.id, position: 2.1 }]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context 'with queue_items that do not belong to the user' do
      let(:bob) { Fabricate(:user) }
      let(:alice) { Fabricate(:user) }
      let(:queue_item1) { Fabricate(:queue_item, user: bob, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 2) }

      it 'does not change the queue items' do
        set_current_user(alice)
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 2 }, { id: queue_item2.id, position: 1 }]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    it_behaves_like "require sign in" do
      let(:action) { post :update_queue }
    end
  end
end
