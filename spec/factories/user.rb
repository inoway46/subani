FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { password }

    after(:create) do |user|
      create_list(:user_content, 1, user:, content: create(:content))
    end
  end
end
