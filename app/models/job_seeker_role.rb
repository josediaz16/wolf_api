class JobSeekerRole < ApplicationRecord
  belongs_to :job_seeker
  belongs_to :role
end
