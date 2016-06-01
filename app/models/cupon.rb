class Cupon < ActiveRecord::Base
  validates :value, presence: true
  validates :value, length: { is: 9 }

  belongs_to :order

  def self.cheking(params)
    where(value: params).first
  end
end
