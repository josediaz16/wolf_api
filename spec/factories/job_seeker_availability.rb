FactoryBot.define do
  factory :job_seeker_availability do
    association :job_seeker
    date_start { Date.current }
    date_end { Date.current + 1.days }
  end
end
