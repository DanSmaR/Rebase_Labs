FROM ruby:3.2

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ruby database/database_setup.rb ; ruby app/server.rb
