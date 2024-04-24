class Location < ApplicationRecord
  # attribute :long_lat, :st_point, srid: 4326, geographic: true # 4326 is Latitude/Longitude

  belongs_to :locatable, polymorphic: true
end
