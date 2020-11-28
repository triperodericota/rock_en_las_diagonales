FROM ruby:2.7-alpine

RUN apk add --no-cache --update build-base git linux-headers nodejs sqlite sqlite-dev tzdata yarn imagemagick

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /app

COPY . .
COPY bin/entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

RUN bundle install

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3100

CMD ["rails", "server", "-b", "0.0.0.0"]
