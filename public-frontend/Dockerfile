# Stage 1: Use an official Node.js runtime as a base image
FROM node:20-alpine

# Set the working directory in the container to /app
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker's layer caching.
# This way, dependencies are only re-installed if package.json changes.
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of your app's source code into the container
# Note: This step is technically optional if you always use a volume mount
# in docker-compose, but it's good practice to have a runnable image.
COPY . .

# Expose the port the Angular app runs on (e.g., 4200)
# This should match the port in your ng serve command
EXPOSE 4200

# The command to run when the container starts.
# This will execute the "start" script from your package.json.
CMD ["npm", "run", "dev"]

