require "spec_helper"

feature "user interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do
    south_park = Fabricate(:video, title: "South Park")
    monk = Fabricate(:video, title: "Monk")
    futurama = Fabricate(:video, title: "Futurama")

    sign_in

    add_video_to_queue(south_park)
    expect_video_in_queue(south_park)

    visit video_path(south_park)
    expect_link_not_to_be_seen("+ My Queue")

    add_video_to_queue(monk)
    add_video_to_queue(futurama)

    set_video_position(south_park, 3)
    set_video_position(monk, 1)
    set_video_position(futurama, 2)
    update_queue

    expect_video_position(south_park, 3)
    expect_video_position(monk, 1)
    expect_video_position(futurama, 2)
  end

  def expect_video_in_queue(video)
    expect(page).to have_content(video.title)
  end

  def expect_link_not_to_be_seen(link)
    expect(page).to_not have_content(link)
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link "+ My Queue"
  end

  def update_queue
    click_button "Update Instant Queue"
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in("queue_items[][position]", with: position)
    end
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end
end
