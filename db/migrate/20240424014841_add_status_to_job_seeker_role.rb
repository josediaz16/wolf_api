class AddStatusToJobSeekerRole < ActiveRecord::Migration[7.1]
  def change
    add_column :job_seeker_roles, :status, :boolean, default: true
  end
end
