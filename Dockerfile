FROM ruby:2.7

# RUN curl -fsSL https://deb.nodesource.com/setup_17.x | bash -

# Install yarn, for webpack
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn postgresql

RUN apt-get update -qq && apt-get install -y build-essential

RUN apt-get update -qq && apt-get install -y sqlite3 libsqlite3-dev


RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

ENV GEM_HOME /myapp/.bundle
ENV BUNDLE_PATH=$GEM_HOME \
  BUNDLE_APP_CONFIG=$BUNDLE_PATH \
  BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH /app/bin:$BUNDLE_BIN:$PATH
ENV NODE_OPTIONS=--openssl-legacy-provider

# RUN mkdir /myapp/db
# RUN /usr/bin/sqlite3 /myapp/db/test.db
