class CreateJobSeekerAvailabilities < ActiveRecord::Migration[7.1]
  def change
    create_table :job_seeker_availabilities do |t|
      t.references :job_seeker, null: false, foreign_key: true
      t.boolean :available, default: false, null: false
      t.date :availability_date, null: false
      t.timestamps
    end
  end
end
