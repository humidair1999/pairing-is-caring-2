class User < ActiveRecord::Base
    before_save { self.username = username.downcase }
    before_save { self.email = email.downcase }

    has_secure_password

    # TODO: more thorough validations
    validates_presence_of :username, :email, :password, :on => :create
end
