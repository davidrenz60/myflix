require "spec_helper"

feature "User registers", js: true, vcr: true do
  background do
    visit register_path
  end

  scenario "with valid user info and credit card" do
    enter_valid_user_info
    enter_valid_credit_card
    click_button "Sign Up"
    expect(page).to have_content("You are registered with MyFlix! Please sign in.")
  end

  scenario "with valid user info and declined card" do
    enter_valid_user_info
    enter_declined_credit_card
    click_button "Sign Up"
    expect(page).to have_content("Your card was declined.")
  end

  scenario "with valid user info and expired card" do
    enter_valid_user_info
    enter_expired_credit_card
    click_button "Sign Up"
    expect(page).to have_content("Your card has expired.")
  end

  scenario "with invalid user and valid credit card" do
    enter_invalid_user_info
    enter_valid_credit_card
    click_button "Sign Up"
    expect(page).to have_content("Please fix the errors below.")
  end

  scenario "with invalid user and declined credit card" do
    enter_invalid_user_info
    enter_declined_credit_card
    click_button "Sign Up"
    expect(page).to have_content("Please fix the errors below.")
  end

  scenario "with invalid user and expired credit card" do
    enter_invalid_user_info
    enter_expired_credit_card
    click_button "Sign Up"
    expect(page).to have_content("Please fix the errors below.")
  end

  def enter_valid_user_info
    fill_in "Email Address", with: "Joe@test.com"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Joe Smith"
  end

  def enter_invalid_user_info
    fill_in "Email Address", with: "Joe@test.com"
    fill_in "Password", with: "password"
  end

  def enter_valid_credit_card
    within_frame "__privateStripeFrame3" do
      fill_in 'cardnumber', with: '4242424242424242'
      fill_in 'exp-date', with: '0119'
      fill_in 'cvc', with: '123'
      fill_in 'postal', with: '12345'
    end
  end

  def enter_expired_credit_card
     within_frame "__privateStripeFrame3" do
      fill_in 'cardnumber', with: '4000000000000069'
      fill_in 'exp-date', with: '0119'
      fill_in 'cvc', with: '123'
      fill_in 'postal', with: '12345'
    end
  end

  def enter_declined_credit_card
     within_frame "__privateStripeFrame3" do
      fill_in 'cardnumber', with: '4000000000000002'
      fill_in 'exp-date', with: '0119'
      fill_in 'cvc', with: '123'
      fill_in 'postal', with: '12345'
    end
  end
end