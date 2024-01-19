FactoryBot.define do
  factory :task do
    card
    name { 'MyString' }
    checked { false }
    position { 1 }
    type { 'DeveloperTask' }
  end
end
