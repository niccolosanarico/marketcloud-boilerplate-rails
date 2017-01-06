module SessionsHelper

    def sign_in(user)
        cookies.permanent[:remember_token] = user.token
        cookies.permanent[:user_id] = user.id
        self.current_user = user
    end

    def current_user=(user)
        @current_user = user
    end

    def current_user
        @current_user ||= User.find(cookies[:user_id].to_i)
    end

    def signed_in?
        !current_user.nil?
    end

    def sign_out
        self.current_user = nil
        cookies.delete(:remember_token)
        cookies.delete(:user_id)
    end
end
