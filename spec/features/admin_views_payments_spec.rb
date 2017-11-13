require "spec_helper"

feature "admin views payments"  do
  let(:admin) { Fabricate(:admin) }
  let(:alice) { Fabricate(:user) }

  background { Fabricate(:payment, user: alice, amount: 999, reference_id: "12345") }

  scenario "admin logs in and views payments" do
    sign_in(admin)
    visit admin_payments_path

    expect(page).to have_content(alice.full_name)
    expect(page).to have_content("$9.99")
    expect(page).to have_content("12345")
  end

  scenario "regular user cannot view payments" do
    sign_in
    visit admin_payments_path

    expect(page).not_to have_content(alice.full_name)
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("12345")
  end
end