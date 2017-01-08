module SessionsHelper

    def sign_in(user)
        session[:user_id] = user.id
    end

    def current_user=(user)
        @current_user = user
    end

    def current_user
      if (user_id = session[:user_id])
        @current_user ||= User.find(user_id)
      elsif (user_id = cookies.signed[:user_id])
        user = User.find(user_id)
        if user && user.authenticated?(:remember, cookies[:remember_token])
          sign_in user
          @current_user = user
        end
      end
    end

    def signed_in?
        !current_user.nil?
    end

    def sign_out
      forget(current_user)
      @current_user = nil
      session.delete(:user_id)
    end

    def remember(user)
      user = user.remember
      cookies.permanent.signed[:user_id] = user.id
      cookies.permanent[:remember_token] = user.remember_token
    end

    # Forgets a persistent session.
    def forget(user)
      user = user.forget
      cookies.delete(:user_id)
      cookies.delete(:remember_token)
    end
end
