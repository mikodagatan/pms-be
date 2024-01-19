FactoryBot.define do
  factory :project do
    sequence(:name) { |i| "SampleProject #{i}" }
    sequence(:code) { |i| "SMPL#{i}" }
  end
end
