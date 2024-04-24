class CreateJobSeekerRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :job_seeker_roles do |t|
      t.references :job_seeker, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true
      t.integer :rating, default: 0, null: false
      t.timestamps

      t.index [:job_seeker_id, :role_id], unique: true
    end
  end
end
