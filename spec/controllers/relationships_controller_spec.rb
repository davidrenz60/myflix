require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    context "with authenticated user" do
      let(:alice) { Fabricate(:user) }
      let(:bob) { Fabricate(:user) }

      it "sets @relationships to the current user's following relatinships" do
        set_current_user(alice)
        Fabricate(:relationship, leader: bob, follower: alice)
        get :index
        expect(assigns(:relationships)).to eq(alice.following_relationships)
      end
    end

    it_behaves_like "require sign in" do
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do
    context "with authenticated user" do
      let(:alice) { Fabricate(:user) }
      let(:bob) { Fabricate(:user) }
      let(:chris) { Fabricate(:user) }

      before { set_current_user(alice) }

      it "deletes the relationship if the current user is the follower" do
        relationship = Fabricate(:relationship, leader: bob, follower: alice)
        post :destroy, id: relationship.id
        expect(Relationship.count).to eq(0)
      end

      it "only deletes the relationship if the follower is the current user" do
        relationship = Fabricate(:relationship, leader: bob, follower: chris)
        post :destroy, id: relationship.id
        expect(Relationship.count).to eq(1)
      end

      it "redirects to the people page" do
        relationship = Fabricate(:relationship, leader: bob, follower: alice)
        post :destroy, id: relationship.id
        expect(response).to redirect_to people_path
      end
    end

    it_behaves_like "require sign in" do
      let(:action) { get :destroy, id: 3 }
    end
  end
end