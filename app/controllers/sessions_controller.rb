class SessionsController < ApplicationController

    def new
    end

    def create
        user = User.find_by_email(params[:session][:email].downcase)
        if (user.authenticate!(params[:session][:password]))
          if user.activated?
            # Sign in the user & redirect to the user's show page
            sign_in user
            params[:session][:remember_me] == '1' ? remember(user) : forget(user)
            redirect_back_or user
          else
            message  = I18n.t('account_not_activated')
            flash[:error] = message
            redirect_to root_url
          end
        else
            # TODO create an error message, re-render the form and log the login tentative
            flash.now[:error] = 'Failed login. This has been logged and notified'
            # log = Log.new(:notice => "Failed login", :desc => "#{request.remote_ip} - #{params[:session][:email]} - #{params[:session][:password]}")
            # log.save
            render 'new'
        end
    end

    def destroy
      sign_out if signed_in?
      redirect_to root_url
    end
end
