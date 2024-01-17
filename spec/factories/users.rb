FactoryBot.define do
  factory :user do
    first_name { "MyString" }
    last_name { "MyString" }
    email { "user@example.com" }
    google_photo_url { "MyString" }
    password { "password123" }
    password_confirmation { "password123" }
  end
end
