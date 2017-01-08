class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by_email(params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update!(options: { activated: true, activated_at: Time.zone.now})
      sign_in user
      flash[:success] = I18n.t('account_activated')
      redirect_to user_path(user.id)
    else
      flash[:danger] = I18n.t('invalid_activation_link')
      redirect_to root_url
    end
  end
end
