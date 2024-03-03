FROM ruby:3.2

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD [ "ruby", "app/server.rb" ]