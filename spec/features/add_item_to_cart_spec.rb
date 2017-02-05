require 'rails_helper'

RSpec.feature "A user adds an item to cart", :type => :feature do

  scenario "and finds the product in the cart" do
    navigate_to_product

    click_button 'add_to_cart'

    expect(page).to have_text("Your order")
  end

end
