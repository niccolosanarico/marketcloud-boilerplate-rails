module ApplicationHelper

  # Saves the current location for returning later
  def store_location
    session[:return_to] = if request.get?
      request.url
    else
      request.referer
    end
  end

  # Get back to previously saved location
  def redirect_back_or_default(default = root_url)
    redirect_to(session[:return_to] || request.referer || default)
    session[:return_to] = nil
  end

  # Flash from https://gist.github.com/suryart/7418454

  def flash_messages(opts = {})
    bootstrap_type = { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }.stringify_keys

    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_type[msg_type]} fade in") do
              concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
              concat message
            end)
    end
    nil
  end

  # Printer
  def pretty_money(amount)
    sprintf "#{Marketcloud.configuration.application.currency_code} %.2f", amount
  end

  # Manage content tags

  def meta_tag(tag, text)
    content_for :"meta_#{tag}", text
  end

  def yield_meta_tag(tag, default_text='')
    content_for?(:"meta_#{tag}") ? content_for(:"meta_#{tag}") : default_text
  end
end
