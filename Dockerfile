FROM ruby:3.3.0

RUN gem install rails:7.1.3
RUN mkdir /wolf_api
WORKDIR /wolf_api

COPY Gemfile* ./
RUN bundle install

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
