FactoryBot.define do
  factory :comment do
    content { 'MyText' }
    commenter { create(:user) }
    resource { create(:card) }
  end
end
