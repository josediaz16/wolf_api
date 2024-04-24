class JobSeekerAvailability < ApplicationRecord
  belongs_to :job_seeker

  validates :availability_date_start, :availability_date_end, presence: true
end
