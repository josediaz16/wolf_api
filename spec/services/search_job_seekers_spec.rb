require 'rails_helper'

RSpec.describe SearchJobSeekers do
  describe '#call' do
    subject { described_class.new(filters) }
    let(:result) { subject.call }

    context 'filtering by role' do
      let!(:job_seeker) { create(:job_seeker) }
      let!(:job_seeker2) { create(:job_seeker) }
      let!(:job_seeker3) { create(:job_seeker) }

      let!(:role) { create(:role) }
      let!(:role2) { create(:role) }

      let!(:job_seeker_role) { create(:job_seeker_role, job_seeker:, role:, status: true) }
      let!(:job_seeker_role2) { create(:job_seeker_role, job_seeker: job_seeker2, role: role2) }
      let!(:job_seeker_role3) do
        create(:job_seeker_role, job_seeker: job_seeker3, role:, status: false) # Discarded because not interested
      end
      let(:filters) { { role: role.id } }

      it 'returns the correct job seekers' do
        expect(result.ids).to eq([job_seeker.id])
      end
    end

    context 'filtering by availability' do
      let!(:job_seeker) { create(:job_seeker) }
      let!(:job_seeker2) { create(:job_seeker) }
      let!(:job_seeker3) { create(:job_seeker) }
      let!(:job_seeker4) { create(:job_seeker) }

      let(:filters) do
        {
          availability: [
            Date.new(2024, 3, 14),
            Date.new(2024, 3, 17)
          ]
        }
      end

      let!(:job_seeker_availability3) do
        create(
          :job_seeker_availability,
          job_seeker: job_seeker2,
          date_start: Date.new(2024, 3, 16),
          date_end: Date.new(2024, 3, 17) # Not available this date
        )
      end

      let!(:job_seeker_availability4) do
        create(
          :job_seeker_availability,
          job_seeker: job_seeker3,
          date_start: Date.new(2024, 3, 14), # Not available any date in this range
          date_end: Date.new(2024, 3, 17)
        )
      end

      let!(:job_seeker_availability5) do
        create(
          :job_seeker_availability,
          job_seeker: job_seeker4,
          date_start: Date.new(2024, 3, 19), # Does not matter, Does not match with filtered dates
          date_end: Date.new(2024, 3, 20)
        )
      end

      it 'returns the correct job seekers' do
        expect(result.ids).to match_array([job_seeker.id, job_seeker4.id])
      end
    end

    context 'filtering by location' do
      let!(:job_seeker) { create(:job_seeker) }
      let!(:job_seeker2) { create(:job_seeker) }

      let!(:location1) do
        create(:location, locatable: job_seeker, long_lat: 'POINT(40.750015182472666 -73.98521899776335)') # New York
      end
      let!(:location2) do
        create(:location, locatable: job_seeker2, long_lat: 'POINT(37.873338239593885 -119.53689365200684)') # California
      end

      let(:filters) do
        {
          location: ['40.81531098914994', '-73.9462621323163']
        }
      end

      it 'returns the correct job seekers' do
        expect(result.ids).to eq([job_seeker.id])
      end
    end

    context 'with all filters' do
      let!(:job_seeker) { create(:job_seeker) }
      let!(:job_seeker2) { create(:job_seeker) }
      let!(:job_seeker3) { create(:job_seeker) }
      let!(:job_seeker4) { create(:job_seeker) }
      let!(:job_seeker5) { create(:job_seeker) }

      let!(:role) { create(:role) }

      let!(:job_seeker_role) { create(:job_seeker_role, job_seeker:, role:, status: true, rating: 50) }
      let!(:job_seeker_role2) do
        create(:job_seeker_role, job_seeker: job_seeker2, role:, status: true, rating: 80)
      end
      let!(:job_seeker_role3) { create(:job_seeker_role, job_seeker: job_seeker3, role:, status: true, rating: 50) }
      let!(:job_seeker_role4) do
        create(:job_seeker_role, job_seeker: job_seeker4, role:, status: false) # Discarded by role
      end
      let!(:job_seeker_role5) { create(:job_seeker_role, job_seeker: job_seeker5, role:, status: true, rating: 50) }

      let!(:location1) do
        create(:location, locatable: job_seeker, long_lat: 'POINT(40.750015182472666 -73.98521899776335)') # New York
      end
      let!(:location2) do
        create(:location, locatable: job_seeker2, long_lat: 'POINT(40.750015182472666 -73.98521899776335)') # New York
      end
      let!(:location3) do
        create(:location, locatable: job_seeker3, long_lat: 'POINT(37.873338239593885 -119.53689365200684)') # Discarded by location
      end

      let!(:job_seeker_availability) do
        create(
          :job_seeker_availability,
          job_seeker: job_seeker5,
          date_start: Date.new(2024, 3, 14), # Discarded by availability
          date_end: Date.new(2024, 3, 15)
        )
      end

      let(:filters) do
        {
          role: role.id,
          location: ['40.81531098914994', '-73.9462621323163'],
          availability: [Date.new(2024, 3, 14), Date.new(2024, 3, 17)]
        }
      end

      it 'returns the correct job seekers' do
        expect(result.ids).to eq([job_seeker2.id, job_seeker.id]) # First jobseeker2 bc has more rating
      end

      context 'with limit' do
        subject { described_class.new(filters, limit:) }
        let(:limit) { 1 }

        it 'returns the correct job seekers' do
          expect(result.ids).to eq([job_seeker2.id])
        end
      end
    end
  end
end
