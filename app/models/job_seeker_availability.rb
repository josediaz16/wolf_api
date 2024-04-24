class JobSeekerAvailability < ApplicationRecord
  belongs_to :job_seeker

  validates :date_start, :date_end, presence: true
end
