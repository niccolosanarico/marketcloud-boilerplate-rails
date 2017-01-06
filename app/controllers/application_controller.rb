class ApplicationController < ActionController::Base
  include SessionsHelper
  include CartHelper
  include ApplicationHelper
  include CategoriesHelper

  protect_from_forgery with: :exception

end
