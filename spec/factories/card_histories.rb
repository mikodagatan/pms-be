FactoryBot.define do
  factory :card_history do
    card
    user
    attr { 'card' }
    from { 'MyText' }
    to { 'MyText' }
    action_status { 'normal' }
  end
end
