FactoryBot.define do
  factory :job_seeker_role do
    association :job_seeker
    association :role
  end
end
