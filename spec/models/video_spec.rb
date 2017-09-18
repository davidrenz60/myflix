require "spec_helper"

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews).order(created_at: :desc) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe '#search_by_title' do
    it 'returns an empty array when no match' do
      family_guy = Video.create(title: "Family Guy", description: "very funny!")
      monk = Video.create(title: "Monk", description: "another funny video!")
      expect(Video.search_by_title("south park")).to eq([])
    end

    it 'returns an array of one video for one match' do
      family_guy = Video.create(title: "Family Guy", description: "very funny!")
      monk = Video.create(title: "Monk", description: "another funny video!")
      expect(Video.search_by_title("Family Guy")).to include(family_guy)
    end

    it 'will return an array of one video for a partial match' do
      family_guy = Video.create(title: "Family Guy", description: "very funny!")
      monk = Video.create(title: "Monk", description: "another funny video!")
      expect(Video.search_by_title("Fam")).to include(family_guy)
    end

    it 'returns an array of all matches ordered by created_at' do
      family_matters = Video.create(title: "Family Matters", description: "another funny video!")
      family_guy = Video.create(title: "Family Guy", description: "very funny!", created_at: 1.day.ago)
      expect(Video.search_by_title("Famil")).to eq([family_matters, family_guy])
    end

     it 'returns an array of matches indiffernt of upper or lower case' do
      family_guy = Video.create(title: "Family Guy", description: "very funny!")
      monk = Video.create(title: "Monk", description: "another funny video!")
      expect(Video.search_by_title("famil")).to include(family_guy)
    end

    it 'returns an empty array when search is an empty string' do
      Video.create(title: "Family Guy", description: "very funny!")
      Video.create(title: "Monk", description: "another funny video!")
      expect(Video.search_by_title("")). to eq([])
    end
  end

  describe '#rating' do
    let(:video) { Fabricate(:video) }

    it "returns nil when there are no reviews" do
      expect(video.rating).to be_nil
    end

    it "returns the average rating of the videos to one decimal point" do
      Fabricate(:review, video: video, rating: 4)
      Fabricate(:review, video: video, rating: 2)
      expect(video.rating).to eq(3.0)
    end

    it "rounds the ratings to one decimal point" do
      Fabricate(:review, video: video, rating: 5)
      Fabricate(:review, video: video, rating: 2)
      Fabricate(:review, video: video, rating: 1)
      expect(video.rating).to eq(2.7)
    end
  end
end
