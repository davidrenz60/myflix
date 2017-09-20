require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:video) }

  describe '#video_title' do
    it 'should return the associated video title' do
      video = Fabricate(:video, title: "Monk")
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq("Monk")
    end
  end

  describe '#rating' do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    it 'should return the rating if the user has reviewed the video' do
      Fabricate(:review, video: video, user: user, rating: 4)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(4)
    end

    it 'should return nil if the user has not reviewed the associated video' do
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to be_nil
    end
  end

  describe '#category_name' do
    it 'should return the associated video category name' do
      category = Fabricate(:category, name: "Comedy")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq("Comedy")
    end
  end

  describe '#category' do
    it 'should return the associated video category' do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end
  end
end
