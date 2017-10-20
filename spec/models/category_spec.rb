require "spec_helper"

describe Category do
  it { should have_many(:videos).order(created_at: :desc) }
  it { should validate_presence_of(:name) }

  describe '#recent_videos' do
    let(:comedy) { Fabricate(:category, name: "Comedy") }

    it 'returns an empty array if there are no videos in the category.' do
      expect(comedy.recent_videos).to eq([])
    end

    it 'returns videos in reverse chronological order by created_at' do
      futurama = Fabricate(:video, title: "Futurama", category: comedy, created_at: 1.day.ago)
      monk = Fabricate(:video, title: "Monk", category: comedy)
      expect(comedy.recent_videos).to eq([monk, futurama])
    end

    it 'returns an array of all videos if there are less than 6 in the category' do
      3.times { Fabricate(:video, category: comedy) }
      expect(comedy.recent_videos.count).to eq(3)
    end

    it 'returns an array of 6 videos when there are more than 6 in the category.' do
      7.times { Fabricate(:video, category: comedy) }
      expect(comedy.recent_videos.count).to eq(6)
    end

    it 'returns the 6 most recent videos' do
      6.times { Fabricate(:video, category: comedy) }
      south_park = Fabricate(:video, title: "South Park", created_at: 1.day.ago, category: comedy)
      expect(comedy.recent_videos).not_to include(south_park)
    end
  end
end
