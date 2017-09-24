require "spec_helper"

describe ApplicationHelper do
  describe "#display_rating" do
    it "returns 'No reviews yet' when ratings are nil" do
      expect(display_rating(nil)).to eq("No reviews yet")
    end

    it "returns the rating followed by /5.0 when there is a rating" do
      expect(display_rating(3.5)).to eq("3.5/5.0")
    end
  end
end