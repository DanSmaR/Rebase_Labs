FROM ruby:3.2

WORKDIR /usr/src/app/backend

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ruby -e "require './src/database/database_setup.rb'; DatabaseSetup.seed"; ruby src/server.rb
