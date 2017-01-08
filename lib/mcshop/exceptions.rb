module Mcshop
  module Exceptions
    class PasswordMatchError < StandardError; end
    class PasswordTooShortError < StandardError; end
    class EmailNotValidError < StandardError; end
  end
end
