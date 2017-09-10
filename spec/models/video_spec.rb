require "spec_helper"

describe Video do
  it "saves itself" do
    video = Video.new(title: "Family Guy", description: "family guy description.")
    video.save
    expect(Video.first).to eq(video)
  end
end