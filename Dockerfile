# Dockerfile
FROM ruby:3.2-slim

# Installation des dépendances système minimales
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libyaml-dev \
    libmariadb-dev \
    default-mysql-client \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install gems
COPY Gemfile ./

RUN bundle install

# Copy the rest of the application code
COPY . .

EXPOSE 3000

CMD ["bash", "-c", "bin/rails db:create db:migrate && bin/rails server -b 0.0.0.0 -p 3000"]
