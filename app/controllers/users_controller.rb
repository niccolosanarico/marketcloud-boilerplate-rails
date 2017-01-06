class UsersController < ApplicationController
  def new
    @user = User.new nil
  end

  def show
    if !current_user || current_user.id != params[:id].to_i
      flash[:error] = I18n.t('forbidden')
      redirect_to root_path and return
    end

    @user = User.find(params[:id])
    @orders = Order.find_by_user(@user.id)
  end

  def create
    if !User.check_password(user_params[:password], user_params[:password_confirmation])
      flash.now[:error] = I18n.t('pw_error')
      render 'new' and return
    end

    if user_params[:password].length < 8
      flash.now[:error] = I18n.t('pw_error_length')
      render 'new' and return
    end

    begin
      @user = User.create(user_params[:name], user_params[:email], user_params[:password])
    rescue Marketcloud::ExistingUserError
      flash.now[:error] = I18n.t('existing_email')
      render 'new' and return
    end

    if @user
      flash[:success] = I18n.t('new_user_welcome')
      sign_in @user
      redirect_to root_path
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
