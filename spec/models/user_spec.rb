require 'spec_helper'

describe User do
  it { should have_many(:reviews).order("created_at DESC") }
  it { should have_many(:queue_items).order(:position) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_secure_password }

  describe "#video_in_queue?" do
    it "should return true if the video is in the queue for the user" do
      alice = Fabricate(:user)
      monk = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: alice, video: monk)
      expect(alice.video_in_queue?(monk)).to be true
    end

    it "should return false if the video is not in the queue for the user" do
      alice = Fabricate(:user)
      monk = Fabricate(:video)
      expect(alice.video_in_queue?(monk)).to be false
    end
  end
end