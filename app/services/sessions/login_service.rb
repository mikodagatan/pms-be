module Sessions
  class LoginService
    attr_reader :user, :email, :password, :errors, :token, :remember_me

    def initialize(params)
      @email = params[:email]
      @password = params[:password]
      @remember_me = params[:remember_me]
      @errors = { email: [], password: [] }
    end

    def call
      @user = User.find_by(email:) || User.find_by(username: email)

      return add_email_not_found_error unless user
      return add_password_error unless passwords_are_same

      @token = Jwt.encode(remember_me ? email_only_hash : encode_hash)
      true
    end

    private

    def add_email_not_found_error
      @errors[:email] << 'is not found'
      false
    end

    def add_password_error
      @errors[:password] << 'is invalid'
      false
    end

    def encode_hash
      { email: user.email, exp: 16.hours.from_now.to_i }
    end

    def email_only_hash
      encode_hash.except(:exp)
    end

    def passwords_are_same
      BCrypt::Password.new(user.password_digest) == password
    end
  end
end
