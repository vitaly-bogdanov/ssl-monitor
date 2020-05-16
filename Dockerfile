FROM ruby:2.6.3

RUN apt-get update -qq
RUN apt-get install -y nodejs build-essential apt-utils \
     autoconf libc6-dev automake libtool bison pkg-config \
     zlib1g zlib1g-dev curl \
     postgresql postgresql-client postgresql-contrib libpq-dev \
     openssl libssl-dev libcurl4-openssl-dev \
     libyaml-dev libxml2-dev libxslt1-dev \
     redis-server imagemagick
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN gem install bundler
COPY . /myapp
RUN bundle install --jobs 20 --retry 5

# EXPOSE 3000

# # Start the main process.
# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]