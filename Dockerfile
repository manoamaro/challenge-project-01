FROM ruby:2.3.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN gem update --system

RUN mkdir /app

WORKDIR /app

ADD ./Gemfile /app/
ADD ./Gemfile.lock /app/
RUN bundle install

ADD . /app

RUN bundle exec rake assets:precompile RAILS_ENV=production

EXPOSE 3000
