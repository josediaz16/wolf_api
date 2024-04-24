# Job Seekers

Presents a simple service to search for job seekers that match the specified criteria. For more details
check the [SPEC](https://wolfxyz.notion.site/Engineering-Task-Data-Modeling-Job-Seeker-c64b5388573349ebb8acf84ef2c3de74)

## Getting Started

This project was setup using Docker and Docker Compose.

1. Install docker and docker compose in your system.
2. Run `docker-compose build` to build the local image
3. Run `docker-compose run web bundle install` to install gems
4. Run `docker-compose run web rails db:create` to create the database
5. Run `docker-compose run web rails db:migrate` to initialize the database

## Testing

Run `docker-compose run web rspec` to run the test suite.

## Considerations

1. The project uses PostgreSQL with PostGIS extension to provide spatial search capabilities. For more details on PostGIS, check the [PostGIS](https://postgis.net/documentation/manual/) documentation.
2. The availability of job_seekers is managed in the following way.
  - A job seeker availability is handled by the `job_seekers_availabilities` table.
  - It makes the assumption that a job seeker is available by default in any date.
  - When a record is created in the `job_seekers_availabilities` table, it stores a range of dates when the job seeker is unavailable. This is done to prevent having to store too many dates for when a job seeker is available and it also facilitates querying.
3. Multiple indexes were added to the columns more frequently used for the search, including an index for the geo field used for locations.
4. The main code to build the queries is in the `SearchJobSeekers` service class.
5. Unit tests were added to make sure the queries work correctly by filter and all together.
6. The code is more focused on performance, however the ORM was primarily used to facilitate building dynamic queries.

## Data model

![image](https://github.com/josediaz16/wolf_api/assets/16386555/b03dede9-765d-4a72-81f0-d9e1a766f62c)



## Pending

- Clean up code to ensure extensibility so that more filters can be added without modifying the base logic.
