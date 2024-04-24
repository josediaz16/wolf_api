class Location < ApplicationRecord
  # attribute :long_lat, :st_point, srid: 4326, geographic: true # 4326 is Latitude/Longitude

  belongs_to :locatable, polymorphic: true

  def self.by_distance(point:, distance:)
    where(
      "
        ST_DWithin(
          locations.long_lat,
          'POINT(#{point.join(' ')})',
          :distance
        )
      ",
      distance:
    )
  end
end
