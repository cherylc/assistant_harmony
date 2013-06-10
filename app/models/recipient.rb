class Recipient < ActiveRecord::Base
  attr_accessible :email

  validates :email, presence: true,
    length: {maximum: 255},
    format: {
      with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]+\z/i
    }

  belongs_to :assignment
end
