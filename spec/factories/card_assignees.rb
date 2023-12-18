FactoryBot.define do
  factory :card_assignee do
    card
    assignee { create(:user) }
  end
end
