# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.4
ARG WORKSPACE_DIR=/workspaces/resource_quotable

FROM arm64v8/ruby:$RUBY_VERSION

RUN apt-get update -qq && apt-get install -y build-essential
RUN apt-get update -qq && apt-get install -y sqlite3 libsqlite3-dev

ARG WORKSPACE_DIR

RUN mkdir -p $WORKSPACE_DIR
WORKDIR $WORKSPACE_DIR

ENV GEM_HOME $WORKSPACE_DIR/.bundle
ENV BUNDLE_PATH=$GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH
ENV BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH /app/bin:$BUNDLE_BIN:$PATH
ENV RUBYOPT="-W:no-experimental"
