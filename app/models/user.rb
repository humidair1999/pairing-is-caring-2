# TODO: add twitter handle (remove @ symbol if it exists)
# TODO: add short bio text area (remember to escape shit)

class User < ActiveRecord::Base
    attr_accessor :remember_token

    before_save { self.username = username.downcase }
    before_save { self.email = email.downcase }

    has_secure_password

    # TODO: more thorough validations
    validates_presence_of :username, :email, :password

    # TODO: is case_sensitive check necessary with the downcases above?
    validates :email, length: { maximum: 160 }, uniqueness: { case_sensitive: false }
    validates :username, length: { maximum: 30 }, uniqueness: { case_sensitive: false }

    has_many :appointments
    has_many :appointment_requests

    # returns the hash digest of the given string
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    # returns a random token
    # doesn't require a User instance, so it can be a class method
    def User.new_token
        SecureRandom.urlsafe_base64
    end

    def remember
        self.remember_token = User.new_token

        update_attribute(:remember_digest, User.digest(remember_token))
    end

    # Returns true if the given token matches the digest.
    def authenticated?(remember_token)
        return false if remember_digest.nil?

        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    # Forgets a user.
    def forget
        update_attribute(:remember_digest, nil)
    end
end
