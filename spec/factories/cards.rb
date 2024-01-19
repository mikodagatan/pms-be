FactoryBot.define do
  factory :card do
    column
    sequence(:name) { |i| "Card #{i}" }
    description { 'MyText' }
    priority { 1 }
    position { 1 }
  end
end
