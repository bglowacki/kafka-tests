FROM ruby

RUN gem install bundler
WORKDIR /app
COPY Gemfile .
COPY Gemfile.lock .
COPY . /app
RUN bundle install

CMD ["bundle", "exec", "ruby", "publisher.rb"]
