class UserMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def account_activation(user)
    @user = user
    mail to: user.email, subject: I18n.t('user_mailer.account_activation.subject')
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: I18n.t('user_mailer.password_reset.subject')
  end

  def confirm_order(user, order)
    @user = user
    @order = order
    mail to: user.email, subject: I18n.t('user_mailer.confirm_order.subject')
  end
end
