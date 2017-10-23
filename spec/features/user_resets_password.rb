require "spec_helper"

feature "user resets password" do
  let(:alice) { Fabricate(:user, password: "old_password") }

  scenario "user resets password through email link" do
    visit sign_in_path
    click_link "Forgot Password?"
    fill_in "Email Address", with: alice.email
    click_button "Send Email"

    open_email(alice.email)
    current_email.click_link("Reset my password")
    fill_in "New Password", with: "new_password"
    click_button "Reset Password"

    fill_in "Email Address", with: alice.email
    fill_in "Password", with: "new_password"
    click_button "Sign in"
    expect(page).to have_content("Welcome #{alice.full_name}! You are signed in.")
  end
end