require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:video) }
  # TODO: figure out how to test it { should validate_uniqueness_of(:video).scoped_to(:user) }
  it { should validate_numericality_of(:position).only_integer }

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

  describe '#rating=' do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let(:queue_item) { Fabricate(:queue_item, user: user, video: video) }

    it 'creates a review with the rating if the review was not present' do
      queue_item.rating = 5
      expect(Review.first.rating).to eq(5)
    end

    it 'updates the associated review if the review is present' do
      Fabricate(:review, user: user, video: video, rating: 2)
      queue_item.rating = 5
      expect(Review.first.rating).to eq(5)
    end

    it 'clears the rating of the review if the review is present' do
      Fabricate(:review, user: user, video: video, rating: 2)
      queue_item.rating = nil
      expect(Review.first.rating).to be_nil
    end

    it 'does not create a new review if a review was not present' do
      queue_item.rating = ""
      expect(Review.count).to be(0)
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
