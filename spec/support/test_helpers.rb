require 'rails_helper'

module TestHelpers
  module Features
    def signin_user(email, password)
      visit new_session_path

      fill_in 'email',    with: email
      fill_in 'password', with: password

      click_button 'signin'
    end
  end
end
