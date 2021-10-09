class User < ApplicationRecord
    has_secure_password
    
    has_many :bank_accounts
    validates_presence_of :first_name, :last_name, :middle_name, :username, :user_number, :password_digest, :phone_number, :email
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
    validates_uniqueness_of :email, :username
    validates :email,
              presence: true,
              length: { maximum: 30 },
              format: { with: VALID_EMAIL_REGEX }
    before_save :format_name
  
    def format_name
      self.first_name = self.first_name.upcase
      self.last_name = self.last_name.upcase
      self.middle_name = self.middle_name.upcase
    end
  
    def to_s
      "#{last_name}, #{first_name}, #{middle_name}"
    end
  end
  