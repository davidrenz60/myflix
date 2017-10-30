require "spec_helper"

feature "admin adds a video" do
  let(:admin) { Fabricate(:admin) }
  let!(:comedy) { Fabricate(:category, name: "Comedy") }

  scenario "admin successfully adds video" do
    sign_in(admin)
    add_video

    sign_out
    sign_in

    expect_video_to_be_added
  end

  def add_video
    visit new_admin_video_path
    fill_in "Title", with: "Monk"
    select "Comedy", from: "Category"
    fill_in "Description", with: "a comedy show"
    attach_file "Large Cover", "spec/support/uploads/monk_large.jpg"
    attach_file "Small Cover", "spec/support/uploads/monk.jpg"
    fill_in "Video URL", with: "www.test.com/monk.mp4"
    click_button "Add Video"
  end

  def expect_video_to_be_added
    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='www.test.com/monk.mp4']")
  end
end
