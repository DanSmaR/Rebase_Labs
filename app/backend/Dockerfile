FROM ruby:3.2

WORKDIR /usr/src/app/backend

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ruby src/import_from_csv.rb ; ruby src/server.rb
