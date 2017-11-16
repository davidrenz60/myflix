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

  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index

        expect(Video.search("whatever").records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        futurama = Fabricate(:video)
        south_park = Fabricate(:video)
        refresh_index

        expect(Video.search("").records.to_a).to eq []
      end

      it "returns an array of 1 video for title case insensitve match" do
        futurama = Fabricate(:video, title: "Futurama")
        south_park = Fabricate(:video, title: "South Park")
        refresh_index

        expect(Video.search("futurama").records.to_a).to eq [futurama]
      end

      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek")
        star_wars = Fabricate(:video, title: "Star Wars")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_trek, star_wars]
      end
    end

    context "with title and description" do
      it "returns an array of many videos based for title and description match" do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "sun is a star")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_wars, about_sun]
      end
    end

    context "multiple words must match" do
      it "returns an array of videos where 2 words match title" do
        star_wars_1 = Fabricate(:video, title: "Star Wars: Episode 1")
        star_wars_2 = Fabricate(:video, title: "Star Wars: Episode 2")
        bride_wars = Fabricate(:video, title: "Bride Wars")
        star_trek = Fabricate(:video, title: "Star Trek")
        refresh_index

        expect(Video.search("Star Wars").records.to_a).to match_array [star_wars_1, star_wars_2]
      end
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

    it 'returns nil when there is a video with a nil rating' do
      review = Fabricate(:review, video: video, rating: 5)
      review.update_attribute(:rating, nil)
      expect(video.rating).to be_nil
    end
  end
end
