class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	validates :email, :password, :firstname, :lastname, presence: true
	#validates :email, uniqueness: true

	has_many   :ratings
  has_many   :books, through: :ratings
  has_many   :orders
end
