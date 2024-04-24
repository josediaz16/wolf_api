class CreateJobSeekerAvailabilities < ActiveRecord::Migration[7.1]
  def change
    create_table :job_seeker_availabilities do |t|
      t.references :job_seeker, null: false, foreign_key: true
      t.date :date_start, null: false
      t.date :date_end, null: false
      t.timestamps

      t.index %i[job_seeker_id date_start date_end], unique: true
      t.index %i[date_start date_end]
    end
  end
end
