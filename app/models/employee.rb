class Employee < ApplicationRecord
   
    has_secure_password
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@simformsolutions.com/i
    before_save { |employee| employee.email = email.downcase }
    validates :name, presence: true
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
    validates :password, presence: true, length: {minimum:6 }
    validates :password_confirmation, presence: true

end
