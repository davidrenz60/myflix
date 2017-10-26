require 'spec_helper'

describe User do
  it { should have_many(:reviews).order("created_at DESC") }
  it { should have_many(:queue_items).order(:position) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_secure_password }
  it { should have_many(:followers).through(:leading_relationships) }
  it { should have_many(:leading_relationships).class_name("Relationship").with_foreign_key("leader_id") }
  it { should have_many(:leaders).through(:following_relationships) }
  it { should have_many(:following_relationships).class_name("Relationship").with_foreign_key("follower_id") }

  it_behaves_like "tokenable" do
    let(:model) { Fabricate(:user) }
  end

  describe "#video_in_queue?" do
    let(:alice) { Fabricate(:user) }
    let(:monk) { Fabricate(:video) }

    it "should return true if the video is in the queue for the user" do
      Fabricate(:queue_item, user: alice, video: monk)
      expect(alice.video_in_queue?(monk)).to be true
    end

    it "should return false if the video is not in the queue for the user" do
      expect(alice.video_in_queue?(monk)).to be false
    end
  end

  describe "#follows?" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }

    it "should return true if the user follows the other user" do
      Fabricate(:relationship, leader: bob, follower: alice)
      expect(alice.follows?(bob)).to eq(true)
    end

    it "should return false if the user does not follow the other user" do
      expect(alice.follows?(bob)).to eq(false)
    end
  end

  describe "#follow" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }

    it "follows another user" do
      alice.follow(bob)
      expect(alice.follows?(bob)).to eq(true)
    end

    it "does not let the user follow oneself" do
      alice.follow(alice)
      expect(alice.follows?(alice)).to eq(false)
    end
  end
end