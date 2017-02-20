class UsersController < ApplicationController

  def new
    @user = User.new( { name: nil, email: nil, password: nil, password_confirmation: nil } )
  end

  def show
    if !current_user || current_user.id != params[:id].to_i
      flash[:error] = I18n.t('forbidden')
      redirect_to root_path and return
    end

    @user = User.find(params[:id])
    @addresses = Address.find_by_user(params[:id])
    @orders = Order.find_by_user(params[:id])
  end

  def create

    begin
      @user = User.create(user_params[:name], user_params[:email].strip.downcase, user_params[:password], user_params[:password_confirmation])
    rescue Marketcloud::ExistingUserError
      flash.now[:error] = I18n.t('existing_email')
      render 'new' and return
    rescue Mcshop::Exceptions::EmailNotValidError
      flash.now[:error] = I18n.t('invalid_email')
      render 'new' and return
    rescue Mcshop::Exceptions::PasswordMatchError
      flash.now[:error] = I18n.t('pw_error')
      render 'new' and return
    rescue Mcshop::Exceptions::PasswordTooShortError
      flash.now[:error] = I18n.t('pw_error_length')
      render 'new' and return
    end

    if @user
      UserMailer.account_activation(@user).deliver_now
      flash[:success] = I18n.t('new_user_welcome')
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
