FROM ruby:3.3.0

WORKDIR /usr/src/app

COPY Gemfile .
RUN bundle install

COPY . .

CMD [ "ruby", "app/server.rb" ]