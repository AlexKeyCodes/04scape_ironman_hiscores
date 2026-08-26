require "rails_helper"

RSpec.describe "Logging in and out", type: :system do
  before { User.create!(username: "zezima", password: "secret123", role: :admin) }

  it "signs the admin in and out through the form" do
    visit new_session_path

    fill_in "Username", with: "zezima"
    fill_in "Password", with: "secret123"
    click_button "Sign in"

    expect(page).to have_content("Signed in as zezima")

    click_button "Sign out"

    expect(page).to have_content("Coming soon")
    expect(page).not_to have_content("Signed in as")
  end

  it "shows an error for bad credentials" do
    visit new_session_path

    fill_in "Username", with: "zezima"
    fill_in "Password", with: "nope"
    click_button "Sign in"

    expect(page).to have_content("Invalid username or password")
  end
end
