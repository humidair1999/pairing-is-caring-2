class User < ActiveRecord::Base
    has_secure_password

    # TODO: more thorough validations
    validates_presence_of :username, :email, :password, :on => :create
end
