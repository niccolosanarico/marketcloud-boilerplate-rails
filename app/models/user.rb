class User < Marketcloud::User
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessor :password_confirmation,
                :remember_digest,
                :remember_token,
                :activated, # status is a custom field used to check the confirmation cycle => 1. unconfirmed 2. confirmed
                :activation_digest,
                :activation_token,
                :activated_at,
                :reset_digest,
                :reset_token,
                :reset_sent_at

  def initialize(attributes)
    super(attributes)

    if !attributes.nil?
      @activated = attributes['activated']
      @remember_digest = attributes['remember_digest']
      @activation_digest = attributes['activation_digest']
      @activated_at = attributes['activated_at']
    end
  end

  def self.check_password(pw, pw_confirm)
    return pw == pw_confirm
  end

  def self.digest(string)
    BCrypt::Password.create(string, cost: BCrypt::Engine::MIN_COST)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Create a new user - overriding original method in parent for checks
  # @param name [Integer] the user name
  # @param email [Integer] the user email
  # @param password [String] the user password
  # @param password_confirmation [String] the password confirmation string
  # @return the newly created user
  def self.create(name, email, password, password_confirmation)
    if !User.check_password(password, password_confirmation)
      raise Mcshop::Exceptions::PasswordMatchError
    end

    if password.length < 8
      raise Mcshop::Exceptions::PasswordTooShortError
    end

    if !email.match(VALID_EMAIL_REGEX)
      raise Mcshop::Exceptions::EmailNotValidError
    end

    # create the user
    user = super(name, email, password)

    # Create activation digest
    user.create_activation_digest
    # save the activation_digest and change activation to false
    user.update!(options: {activated: false, activation_digest: "#{user.activation_digest}"})

    user
  end

  # Verifies the user has activated its email
  # @return true if user has activated the account
  def activated?
    return activated
  end

  # Returns true if the given token matches the digest.

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update!(options: { remember_digest:  User.digest(remember_token)})
  end

  def forget
    update!(options: { remember_digest: nil })
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def create_reset_digest
    self.reset_token  = User.new_token
    update!(options: { reset_digest:  User.digest(reset_token), reset_sent_at: Time.zone.now})
  end

  #Returns true if a password reset has expired.
  def password_reset_expired?
     reset_sent_at < 24.hours.ago
  end
  
end
