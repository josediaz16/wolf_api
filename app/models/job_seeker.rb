class JobSeeker < ApplicationRecord
  has_many :job_seeker_availabilities
  has_many :job_seeker_roles
  has_many :locations, -> { where(locatable_type: 'JobSeeker') }, as: :locatable
  has_many :roles, through: :job_seeker_roles
end
