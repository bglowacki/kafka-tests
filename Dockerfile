FROM ruby

RUN gem install bundler
WORKDIR /app
COPY Gemfile .
COPY Gemfile.lock .
COPY . /app/lib/
RUN bundle install
ENTRYPOINT ["bundle", "exec", "ruby"]
