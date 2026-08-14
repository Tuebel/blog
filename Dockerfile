FROM docker.io/jekyll/builder:4.4.1
WORKDIR /srv/jekyll
COPY Gemfile Gemfile.lock* ./
RUN bundle install
