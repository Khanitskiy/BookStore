class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many   :ratings
  has_many   :books, through: :ratings
  has_many   :orders, dependent: :destroy

  has_one :billing_address, class_name: 'Address', foreign_key: 'user_billing_address_id'
  has_one :shipping_address, class_name: 'Address', foreign_key: 'user_shipping_address_id'

  validates :firstname, :lastname, presence: true

  mount_uploader :image, FacebookAvatarUploader

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.firstname = auth.info.first_name
      user.lastname = auth.info.last_name
      user.facebook_image = auth.info.image
    end
  end

  def self.country_name(country_code)
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end

end
