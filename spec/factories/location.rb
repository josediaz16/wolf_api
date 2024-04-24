FactoryBot.define do
  factory :location do
    association :locatable, factory: :job_seeker
    long_lat { 'POINT(40.750015182472666 -73.98521899776335)' }
  end
end
