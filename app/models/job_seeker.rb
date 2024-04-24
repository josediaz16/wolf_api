class JobSeeker < ApplicationRecord
  has_many :job_seeker_availabilities
  has_many :job_seeker_roles
  has_many :locations, -> { where(locatable_type: 'JobSeeker') }, as: :locatable
  has_many :roles, through: :job_seeker_roles

  def self.search_by_role(role)
    joins(:job_seeker_roles)
      .where(
        job_seeker_roles: {
          role_id: role,
          status: true
        }
      )
  end
end
