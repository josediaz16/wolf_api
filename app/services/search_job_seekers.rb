# frozen_string_literal: true

# Query Object to search Job Seekers
class SearchJobSeekers
  MILE = 1609

  def initialize(filters)
    @filters = filters.to_h
  end

  def call
    @base_relation = JobSeeker

    add_role_filter
    add_availability_filter
    add_location_filter

    @base_relation
  end

  private

  def add_role_filter
    return unless @filters[:role].present?

    @base_relation =
      @base_relation
      .joins(:job_seeker_roles)
      .where(job_seeker_roles: { role_id: @filters[:role], status: true })
      .order(rating: :desc)
  end

  def add_availability_filter
    return unless @filters[:availability].present?
    raise TypeError, 'availability must be an array' unless @filters[:availability].is_a?(Array)

    @base_relation =
      @base_relation
      .left_joins(:job_seeker_availabilities)
      .where(job_seeker_availabilities: { id: nil })
      .or(JobSeekerAvailability.where.not(build_availability_conditions))
  end

  def add_location_filter
    return unless @filters[:location].present?
    raise TypeError, 'location must be an array' unless @filters[:location].is_a?(Array)

    lat, long = @filters[:location]

    @base_relation =
      @base_relation
      .joins(:locations)
      .where(
        "
          ST_DWithin(
            locations.long_lat,
            'POINT(#{lat} #{long})',
            :distance
          )
        ", distance: MILE * 30
      )
  end

  def build_availability_conditions
    @filters[:availability].map do |availability_date|
      ApplicationRecord.sanitize_sql_array(
        [
          "
            (job_seeker_availabilities.availability_date_start <= :availability_date AND
            job_seeker_availabilities.availability_date_end >= :availability_date)
          ",
          { availability_date: }
        ]
      )
    end.join(' OR ')
  end
end
