class User < ActiveRecord::Base
  attr_accessible :email, :gender, :image, :locale, :name
  attr_accessible :provider, :refresh_token, :expires_at, :token, :uid

  validates :provider, presence: true, inclusion: {in: %w(google_oauth2)}
  validates :uid,      presence: true, length: {maximum: 25},  uniqueness: {scope: :provider}
  validates :token,    presence: true, length: {maximum: 64}
  validates :name,     presence: true, length: {maximum: 100}
  validates :email,    presence: true, length: {maximum: 255}, uniqueness: {case_sensitive: false}
  validates :gender,   inclusion: {in: [0, 1, 2]}
  validates :locale,   length: {maximum: 5}
  validates :image,    length: {maximum: 255}

  has_many :calendars
  has_many :assignments
  has_many :meetings

  def selected_calendars
    calendars.where(selected: true)
  end

  def self.find_with_oauth(hash)
    attributes = {provider: hash["provider"], uid: hash["uid"]}

    user = User.where(attributes).first || User.new(attributes)

    user.attributes = user_attributes(hash)
    user.save if user.changed?
    user
  end

  def self.user_attributes(hash)
    token =  hash["credentials"]["token"]
    refresh_token = hash["credentials"]["refresh_token"]
    expires_at = hash["credentials"]["expires_at"]
    email =  hash["info"]["email"]
    name  =  hash["info"]["name"]
    gender_string = hash["extra"]["raw_info"]["gender"]
    locale = hash["extra"]["raw_info"]["locale"]
    image =  hash["info"]["image"]

    gender = if gender_string == "female"
      1
    elsif gender_string == "male"
      2
    else
      0
    end

    {
      token: token, refresh_token: refresh_token, expires_at: expires_at,
      name: name, gender: gender,
      email: email, locale: locale, image: image
    }
  end

  def female?
    gender == 1
  end

  def male?
    gender == 2
  end
end
