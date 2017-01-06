class SessionsController < ApplicationController

    def new
    end

    def create
        user = User.find_by_email(params[:session][:email].downcase)
        if (user.authenticate!(params[:session][:password]))
            # Sign in the user & redirect to the user's show page
            sign_in user
            redirect_back_or_default
            # redirect_to root_path #TODO redirect to posts admin
        else
            # TODO create an error message, re-render the form and log the login tentative
            flash.now[:error] = 'Failed login. This has been logged and notified'
            # log = Log.new(:notice => "Failed login", :desc => "#{request.remote_ip} - #{params[:session][:email]} - #{params[:session][:password]}")
            # log.save
            render 'new'
        end
    end

    def destroy
        sign_out
        redirect_to root_url
    end
end
