class ChangeAvailabilityDateToRange < ActiveRecord::Migration[7.1]
  def change
    rename_column :job_seeker_availabilities, :availability_date, :availability_date_start
    add_column :job_seeker_availabilities, :availability_date_end, :date, null: false

    add_index :job_seeker_availabilities, :availability_date_start
    add_index :job_seeker_availabilities, :availability_date_end
  end
end
