class User < ApplicationRecord
	has_many :watchers, dependent: :destroy
    has_many :events, through: :watchers
    #Validations
    validates_presence_of :email, :password_digest
    validates :email, uniqueness: true
    #encrypt password
    has_secure_password
end
