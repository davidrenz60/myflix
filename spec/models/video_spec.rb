require "spec_helper"

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews).order(created_at: :desc) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe '#search_by_title' do
    it 'returns an empty array when no match' do
      Fabricate(:video, title: "Family Guy")
      Fabricate(:video, title: "Monk")
      expect(Video.search_by_title("south park")).to eq([])
    end

    it 'returns an array of one video for one match' do
      family_guy = Fabricate(:video, title: "Family Guy")
      monk = Fabricate(:video, title: "Monk")
      expect(Video.search_by_title("Family Guy")).to include(family_guy)
    end

    it 'will return an array of one video for a partial match' do
      family_guy = Fabricate(:video, title: "Family Guy")
      monk = Fabricate(:video, title: "Monk")
      expect(Video.search_by_title("Fam")).to include(family_guy)
    end

    it 'returns an array of all matches ordered by created_at' do
      family_guy = Fabricate(:video, title: "Family Guy")
      family_matters = Fabricate(:video, title: "Family Matters")
      expect(Video.search_by_title("Famil")).to eq([family_matters, family_guy])
    end

     it 'returns an array of matches indiffernt of upper or lower case' do
      family_guy = Fabricate(:video, title: "Family Guy")
      monk = Fabricate(:video, title: "Monk")
      expect(Video.search_by_title("famil")).to include(family_guy)
    end

    it 'returns an empty array when search is an empty string' do
      Fabricate(:video, title: "Family Guy")
      Fabricate(:video, title: "Monk")
      expect(Video.search_by_title("")). to eq([])
    end
  end

  describe '#average_rating' do
    let(:video) { Fabricate(:video) }

    it "returns nil when there are no reviews" do
      expect(video.average_rating).to be_nil
    end

    it "returns the average rating of the videos to one decimal point" do
      Fabricate(:review, video: video, rating: 4)
      Fabricate(:review, video: video, rating: 2)
      expect(video.average_rating).to eq(3.0)
    end

    it "rounds the ratings to one decimal point" do
      Fabricate(:review, video: video, rating: 5)
      Fabricate(:review, video: video, rating: 2)
      Fabricate(:review, video: video, rating: 1)
      expect(video.average_rating).to eq(2.7)
    end

    it 'returns nil when there is a video with a nil rating' do
      review = Fabricate(:review, video: video, rating: 5)
      review.update_attribute(:rating, nil)
      expect(video.average_rating).to be_nil
    end
  end
end
