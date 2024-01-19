FactoryBot.define do
  factory :user do
    first_name { 'First' }
    last_name { 'Last' }
    sequence(:email) { |i| "user#{i}@example.com" }
    sequence(:username) { |i| "username#{i}" }
    google_photo_url { 'MyString' }
    password { 'password123' }
    password_confirmation { 'password123' }
  end
end
