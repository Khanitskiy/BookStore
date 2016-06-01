class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many   :ratings
  has_many   :books, through: :ratings
  has_many   :orders

  has_one :billing_address, class_name: 'Address', foreign_key: 'user_billing_address_id'
  has_one :shipping_address, class_name: 'Address', foreign_key: 'user_shipping_address_id'

  validates :firstname, :lastname, presence: true

  mount_uploader :image, FacebookAvatarUploader

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.firstname = auth.info.first_name # assuming the user model has a name
      user.lastname = auth.info.last_name   # assuming the user model has a name
      user.facebook_image = auth.info.image # assuming the user model has an image
    end
  end
end
