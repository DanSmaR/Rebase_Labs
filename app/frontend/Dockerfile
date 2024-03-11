FROM ruby:3.2

RUN apt-get update && apt-get install -y firefox-esr

WORKDIR /usr/src/app/frontend

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN chmod +x wait-for-it.sh

CMD [ "ruby", "src/server.rb" ]
