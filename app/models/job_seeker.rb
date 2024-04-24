class JobSeeker < ApplicationRecord
  has_many :job_seeker_roles
  has_many :roles, through: :job_seeker_roles
end
