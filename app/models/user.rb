class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable, :timeoutable,
        :omniauthable, omniauth_providers: %i[line]

  has_many :user_contents, dependent: :destroy
  has_many :contents, through: :user_contents
  has_many :schedules, dependent: :destroy
  has_many :line_flags, dependent: :destroy
  has_many :line_flag_contents, through: :line_flags, source: :content

  def social_profile(provider)
    social_profiles.find { |sp| sp.provider == provider.to_s }
  end

  def limit_position(day)
    schedules.where(position: 5).exists?(day:)
  end

  def add_line_flag(content)
    line_flag_contents << content
  end

  def remove_line_flag(content)
    line_flag_contents.destroy(content)
  end

  def show_email
    if provider
      "LINEアカウントで登録中"
    else
      email
    end
  end
end
