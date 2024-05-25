# Use the official Ruby image from the Docker Hub
FROM ruby:2.7

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# Set the work directory
WORKDIR /usr/src/app

# Add the Gemfile and Gemfile.lock to the current directory
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the main application
COPY . .

# Expose port 4567 (default Sinatra port)
EXPOSE 4567

# The command that starts the app
CMD ["ruby", "app.rb", "-o", "0.0.0.0"]
