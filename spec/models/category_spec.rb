require "spec_helper"

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe '#recent_videos' do
    it 'returns an empty array if there are no videos in the category.' do
      comedy = Category.new(name: "Comedy")
      expect(comedy.recent_videos).to eq([])
    end

    it 'returns videos in reverse chronological order by created_at' do
      comedy = Category.create(name: "Comedy")
      futurama = Video.create(title: "Futurama", description: "Very Funny!", category: comedy, created_at: 1.day.ago)
      monk = Video.create(title: "Monk", description: "A good Video.", category: comedy)
      expect(comedy.recent_videos).to eq([monk, futurama])
    end

    it 'returns an array of all videos if there are less than 6 in the category' do
      comedy = Category.create(name: "Comedy")
      Video.create(title: "Monk", description: "A good Video.", category: comedy)
      Video.create(title: "South Park", description: "Funny!", category: comedy)
      Video.create(title: "Futurama", description: "Very Funny!", category: comedy)
      expect(comedy.recent_videos.count).to eq(3)
    end

    it 'returns an array of 6 videos when there are more than 6 in the category.' do
      comedy = Category.create(name: "Comedy")
      7.times do
        Video.create(title: "Monk", description: "A good video!", category: comedy, created_at: 6.days.ago)
      end
      expect(comedy.recent_videos.count).to eq(6)
    end

    it 'returns the 6 most recent videos' do
      comedy = Category.create(name: "Comedy")
      6.times do
        Video.create(title: "Monk", description: "A good video!", category: comedy)
      end

      south_park = Video.create(title: "South Park", description: "Funny!", category: comedy, created_at: 1.day.ago)
      expect(comedy.recent_videos).not_to include(south_park)
    end
  end
end
