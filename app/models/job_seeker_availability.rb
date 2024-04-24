class JobSeekerAvailability < ApplicationRecord
  belongs_to :job_seeker

  validates :availability_date, presence: true
end
