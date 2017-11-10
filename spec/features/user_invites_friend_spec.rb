require "spec_helper"

feature "user invites friend", js: true, vcr: true do
  let(:alice) { Fabricate(:user) }

  scenario "user invites friend and successfully accepts invitation" do
    sign_in(alice)
    invite_a_friend

    friend_accepts_invitation
    friend_signs_in

    friend_should_follow(alice)
    inviter_should_follow_friend(alice)

    clear_email
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "Bob Jones"
    fill_in "Friend's Email Address", with: "bob@test.com"
    fill_in "Message", with: "Please join MyFlix!"
    click_button "Send Invitation"
    sign_out
  end

  def friend_accepts_invitation
    open_email("bob@test.com")
    current_email.click_link("Accept this invitation")
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Bob Jones"
    enter_credit_card_info
    click_button "Sign Up"
  end

  def enter_credit_card_info
    within_frame "__privateStripeFrame3" do
      fill_in 'cardnumber', with: '4242424242424242'
      fill_in 'exp-date', with: '0119'
      fill_in 'cvc', with: '123'
      fill_in 'postal', with: '12345'
    end
  end

  def friend_signs_in
    sleep(1)
    fill_in "Email Address", with: "bob@test.com"
    fill_in "Password", with: "password"
    click_button "Sign in"
  end

  def friend_should_follow(user)
    sleep(1)
    click_link "People"
    expect(page).to have_content(user.full_name)
    sign_out
  end

  def inviter_should_follow_friend(user)
    sign_in(user)
    click_link "People"
    expect(page).to have_content("Bob")
  end
end
