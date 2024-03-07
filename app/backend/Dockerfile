FROM ruby:3.2

WORKDIR /usr/src/app/backend

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ruby src/database/database_setup.rb ; ruby src/server.rb
