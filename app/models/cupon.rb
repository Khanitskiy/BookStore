class Cupon < ActiveRecord::Base
  validates :value, presence: true
  validates :value, length: { is: 9 }

  belongs_to :order

  scope :cheking, ->(param) { where('value LIKE ?', param).all }
end