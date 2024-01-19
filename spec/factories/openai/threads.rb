FactoryBot.define do
  factory :openai_thread, class: 'Openai::Thread' do
    project
    thread_id { 'MyString' }
  end
end
