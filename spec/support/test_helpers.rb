require 'rails_helper'

module TestHelpers
  module Features
    def signin_with(email, password)
      visit new_session_path

      fill_in 'email',    with: "nico@nico.com"
      fill_in 'password', with: "niconico"

      click_button 'signin'
    end

    def navigate_to_product(product_id = 107598)
      visit product_path(product_id)
    end
  end
end
