class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable , omniauth_providers: [:facebook, :google_oauth2]
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  VALID_PHONE_REGEX = /\A\d[0-9]{9}\z/.freeze

  has_many_attached :images
  has_many :ratings, dependent: :destroy
  has_many :orders, dependent: :destroy

  enum role: {admin: 0, member: 1}

  validates :name, presence: true,
            length: {maximum: Settings.validation.user.name_max}
  validates :email, presence: true,
            length: {maximum: Settings.validation.user.email_max},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: true
  validates :phone_number, format: {with: VALID_PHONE_REGEX}, allow_nil: true

  before_save :downcase_email

  def self.from_omniauth auth
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.images = auth.info.images
    end
  end

  private

  def downcase_email
    email.downcase!
  end
end
