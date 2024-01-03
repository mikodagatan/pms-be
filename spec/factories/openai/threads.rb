FactoryBot.define do
  factory :openai_thread, class: 'Openai::Thread' do
    project { nil }
    thread_id { "MyString" }
  end
end
