#!/bin/bash

# Print a message indicating the start of the server
echo -e "Starting PostgreSQL server..."

# Change directory to where the docker-compose.yml file is located
cd ./server || { echo -e "Directory change failed."; exit 1; }

# Load environment variables from the .env file if it exists
if [ -f .env ]; then
  # Export the variables in the .env file
  set -a
  source .env
  set +a
fi

# Start Docker containers in detached mode
docker-compose up -d

# Print a success message indicating PostgreSQL is running
echo -e "PostgreSQL server is running on port ${POSTGRESQL_PORT}!"
