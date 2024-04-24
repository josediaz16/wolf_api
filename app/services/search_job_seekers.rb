# frozen_string_literal: true

# Query Object to search Job Seekers
class SearchJobSeekers
  MILE = 1609
  MAX = 1000

  attr_reader :filters, :miles, :limit

  def initialize(filters, miles: 30, limit: 10)
    @filters = filters.to_h
    @miles = miles
    @limit = [limit, MAX].min
  end

  # TODO: Cleanup this class. Create "Filter" concept and refactor to make sure
  # unlimited filters can be added without modifiying this class
  def call
    @base_relation = JobSeeker

    add_role_filter
    add_availability_filter
    add_location_filter

    @base_relation.limit(limit)
  end

  private

  # Add role filter if present and order by rating
  def add_role_filter
    return unless filters[:role].present?

    @base_relation =
      @base_relation
      .search_by_role(filters[:role])
      .order(rating: :desc)
  end

  # Adds availability filter if present
  def add_availability_filter
    return unless filters[:availability].present? && filters[:availability].is_a?(Array)

    @base_relation =
      @base_relation
      .left_joins(:job_seeker_availabilities)
      .where(job_seeker_availabilities: { id: nil })
      .or(JobSeekerAvailability.where.not(build_availability_conditions))
  end

  # Add location filter if present. Search by distance using PostGIS.
  def add_location_filter
    return unless filters[:location].present? && filters[:location].is_a?(Array)

    lat, long = filters[:location]

    @base_relation =
      @base_relation
      .joins(:locations)
      .merge(Location.by_distance(point: [lat, long], distance:))
  end

  # Build conditions for availability. That means job seekers without any unavailability
  # stored or any unavailability within the date range
  def build_availability_conditions
    @filters[:availability].map do |availability_date|
      ApplicationRecord.sanitize_sql_array(
        [
          "
            (job_seeker_availabilities.date_start <= :availability_date AND
            job_seeker_availabilities.date_end >= :availability_date)
          ",
          { availability_date: }
        ]
      )
    end.join(' OR ')
  end

  def distance
    miles * MILE
  end
end
