FactoryBot.define do
  factory :job_seeker_availability do
    association :job_seeker
    available { true }
    availability_date_start { Date.current }
    availability_date_end { Date.current + 1.days }
  end
end
