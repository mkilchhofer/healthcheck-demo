FROM ruby:slim as builder

RUN apt-get update -qq && \
    apt-get install -y build-essential curl

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

FROM ruby:slim

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app/ /app/

ADD . $APP_HOME

USER www-data
# App is healthy by default
RUN touch /tmp/ready /tmp/live

EXPOSE 9292/tcp
CMD [ "rackup", "-o", "0.0.0.0"]
