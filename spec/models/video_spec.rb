require "spec_helper"

describe Video do
  it "saves itself" do
    video = Video.new(title: "Family Guy", description: "family guy description.")
    video.save
    expect(Video.first).to eq(video)
  end

  it "belongs to a cateogry" do
    comedy = Category.create(name: "Comedy")
    video = Video.create(title: "Family Guy", description: "family guy description.", category: comedy)
    expect(video.category).to eq(comedy)
  end

  it "validates a title" do
    video = Video.create(description: "test description.")
    expect(Video.count).to eq(0)
  end

  it "validates a description" do
    video = Video.create(title: "South Park")
    expect(Video.count).to eq(0)
  end
end