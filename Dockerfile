FROM ruby:slim

RUN apt-get update -qq && \
    apt-get install -y build-essential

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

# App is healthy by default
RUN touch /tmp/ready /tmp/live

ADD . $APP_HOME

CMD [ "rackup", "-o", "0.0.0.0"]
