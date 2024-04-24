# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_240_424_015_640) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'
  enable_extension 'postgis'

  create_table 'job_seeker_availabilities', force: :cascade do |t|
    t.bigint 'job_seeker_id', null: false
    t.boolean 'available', default: false, null: false
    t.date 'availability_date_start', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.date 'availability_date_end', null: false
    t.index ['availability_date_end'], name: 'index_job_seeker_availabilities_on_availability_date_end'
    t.index ['availability_date_start'], name: 'index_job_seeker_availabilities_on_availability_date_start'
    t.index ['job_seeker_id'], name: 'index_job_seeker_availabilities_on_job_seeker_id'
  end

  create_table 'job_seeker_roles', force: :cascade do |t|
    t.bigint 'job_seeker_id', null: false
    t.bigint 'role_id', null: false
    t.integer 'rating', default: 0, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.boolean 'status', default: true
    t.index %w[job_seeker_id role_id], name: 'index_job_seeker_roles_on_job_seeker_id_and_role_id', unique: true
    t.index ['job_seeker_id'], name: 'index_job_seeker_roles_on_job_seeker_id'
    t.index ['role_id'], name: 'index_job_seeker_roles_on_role_id'
  end

  create_table 'job_seekers', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['name'], name: 'index_job_seekers_on_name'
  end

  create_table 'locations', force: :cascade do |t|
    t.string 'locatable_type', null: false
    t.bigint 'locatable_id', null: false
    t.geography 'long_lat', limit: { srid: 4326, type: 'st_point', geographic: true }
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[locatable_type locatable_id], name: 'index_locations_on_locatable'
    t.index ['long_lat'], name: 'index_locations_on_long_lat', using: :gist
  end

  create_table 'roles', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['name'], name: 'index_roles_on_name'
  end

  add_foreign_key 'job_seeker_availabilities', 'job_seekers'
  add_foreign_key 'job_seeker_roles', 'job_seekers'
  add_foreign_key 'job_seeker_roles', 'roles'
end
