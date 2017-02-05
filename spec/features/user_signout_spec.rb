require 'rails_helper'

RSpec.feature "A user signs out", :type => :feature do

  before(:each) do
    signin_with("nico@nico.com", "niconico")
  end

  scenario "and has success" do
    click_link "Sign out"

    expect(page).to have_text("Sign in")
  end

end
