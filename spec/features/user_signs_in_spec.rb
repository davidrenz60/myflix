require "spec_helper"

feature "User signs in" do
  scenario "with valid credentials" do
    alice = Fabricate(:user)
    sign_in(alice)
    expect(page).to have_content(alice.full_name)
  end

  scenario "with account deactivated" do
    alice = Fabricate(:user, active: false)
    sign_in(alice)
    expect(page).not_to have_content(alice.full_name)
    expect(page).to have_content("Your account has been deactivated. Please contact customer service.")
  end
end
