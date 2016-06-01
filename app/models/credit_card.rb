class CreditCard < ActiveRecord::Base
  validates :number, :cvv, :expiration_month, :expiration_year, :firstname, :lastname, presence: true
  validates :number, length: { is: 16 }
  validates :cvv, length: { is: 3 }
  validates :number, :cvv, numericality: { only_integer: true }

  belongs_to :user
  has_many :orders
end
