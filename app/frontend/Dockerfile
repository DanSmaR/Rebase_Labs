FROM ruby:3.2

WORKDIR /usr/src/app/frontend

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN chmod +x wait-for-it.sh

CMD [ "ruby", "src/server.rb" ]

