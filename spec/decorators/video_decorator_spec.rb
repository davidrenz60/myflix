require "spec_helper"

describe VideoDecorator do
  describe "#rating" do
    let(:video) { Fabricate(:video) }

    it "returns 'N/A' when no rating is present" do
      expect(video.decorate.rating).to eq("N/A")
    end

    it "returns the rating followed by /5.0 when there is a rating" do
      Fabricate(:review, video: video, rating: 3)
      expect(video.decorate.rating).to eq("3.0/5.0")
    end
  end
end