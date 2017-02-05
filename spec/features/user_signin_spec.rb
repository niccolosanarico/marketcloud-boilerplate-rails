require 'rails_helper'

RSpec.feature "A user signs in", :type => :feature do

  scenario "with a valid username and password" do
    visit new_session_path

    fill_in 'email',    with: "nico@nico.com"
    fill_in 'password', with: "niconico"

    click_button 'signin'

    expect(page).to have_text("My account")
  end

  scenario "with an invalid username" do
    visit new_session_path

    fill_in 'email',    with: "niconico@nico.com"
    fill_in 'password', with: "niconico"

    click_button 'signin'

    expect(page).not_to have_text("My account")
  end

  scenario "with an invalid password" do
    visit new_session_path

    fill_in 'email',    with: "nico@nico.com"
    fill_in 'password', with: "niconiconico"

    click_button 'signin'

    expect(page).not_to have_text("My account")
  end

end
