class User < ActiveRecord::Base
  TEMP_EMAIL_REGEX = /\Achange@me/

  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  validates :email, format: { without: TEMP_EMAIL_REGEX, on: :update }
  validates :email, :full_name, presence: true

  has_many :identities, dependent: :destroy

  def to_s
    full_name
  end

  def full_name_with_email
    if email_verified?
      "#{self[:full_name]} (#{email})"
    else
      full_name
    end
  end

  def email_verified?
    email !~ TEMP_EMAIL_REGEX
  end
end
