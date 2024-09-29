FROM ruby:3.2

# Update RubyGems to the latest version
RUN gem update --system

# Install specific versions of bundler and ffi
RUN gem install bundler -v 2.4.22
RUN gem install ffi -v 1.17.0

# Install Jekyll
RUN gem install jekyll

# Set the working directory
WORKDIR /usr/src/app

# Copy the project files
COPY . .

# Install dependencies using Bundler
RUN bundle install

# Expose the port Jekyll runs on
EXPOSE 4000

# Command to run Jekyll
CMD ["jekyll", "serve", "--host", "0.0.0.0"]
