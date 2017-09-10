require "spec_helper"

describe Category do
  it 'saves itself' do
    category = Category.new(name: "Comedy")
    category.save
    expect(Category.first).to eq(category)
  end

  it 'has many videos' do
    comedy = Category.create(name: "comedy")
    monk = Video.create(title: "Monk", description: "a description for Monk.", category: comedy)
    south_park = Video.create(title: "South Park", description: "a description for South Park.", category: comedy)
    expect(comedy.videos).to eq([monk, south_park])
  end
end
