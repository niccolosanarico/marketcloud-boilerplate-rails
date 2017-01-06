class User < Marketcloud::User
  attr_accessor :password_confirmation

  def self.check_password(pw, pw_confirm)
    return pw == pw_confirm
  end

end
