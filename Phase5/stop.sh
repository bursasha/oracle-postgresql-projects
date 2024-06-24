#!/bin/bash

# Print a message indicating the stop of the server
echo -e "Stopping PostgreSQL server..."

# Change directory to where the docker-compose.yml file is located
cd ./server || { echo -e "Directory change failed."; exit 1; }

# Stop Docker containers
docker-compose down

# Print a success message indicating PostgreSQL server is stopped
echo -e "PostgreSQL server is stopped!"
