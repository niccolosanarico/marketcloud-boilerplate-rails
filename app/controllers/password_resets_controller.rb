class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by_email(params[:password_reset][:email].downcase)
    if @user.email
      @user.create_reset_digest
      UserMailer.password_reset(@user).deliver_now
      flash[:notice] = I18n.t("reset_sent")
      redirect_to root_url
    else
      flash.now[:alert] = I18n.t("email_not_found")
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      flash[:success] = "Password cannot be empty"
      render 'edit'
    elsif @user.update!(options: {password: params[:user][:password], password_confirmation: params[:user][:password_confirmation]})
      sign_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by_email(params[:email])
  end

  # Confirms a valid user.
  def valid_user
    if !(@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      flash[:alert] = "Not a valid user. #{@user.authenticated?(:reset, params[:id])}"
      redirect_to root_url
    end
  end

  # Checks expiration of reset token.
  def check_expiration
    if @user.password_reset_expired?
      flash[:alert] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end

end
