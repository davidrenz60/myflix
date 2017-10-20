require "spec_helper"

feature "user follows" do
  let(:bob) { Fabricate(:user) }
  let(:monk) { Fabricate(:video) }

  scenario "user follows and unfollows another user" do
    Fabricate(:review, video: monk, user: bob)

    sign_in
    click_on_video_page(monk)

    click_link bob.full_name
    click_link "Follow"
    expect(page).to have_content(bob.full_name)

    unfollow(bob)
    expect(page).to_not have_content(bob.full_name)
  end

  def unfollow(user)
    find(:xpath, "//tr[contains(.,'#{user.full_name}')]//a[i]").click
  end
end