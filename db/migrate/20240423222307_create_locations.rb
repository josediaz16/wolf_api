class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.references :locatable, polymorphic: true, null: false
      t.st_point :long_lat, geographic: true
      t.timestamps

      t.index :long_lat, using: :gist
    end
  end
end
