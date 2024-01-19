FactoryBot.define do
  factory :column do
    project
    name { 'SampleColumn' }
    position { 1 }
  end
end
