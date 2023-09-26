# Use an official Node.js runtime as the base image
FROM node:latest

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the entire project to the container
COPY . .

# Build the Vue.js app for production
RUN npm run build

RUN npm install -g serve

# Start the web server when the container runs
CMD [ "serve", "-s", "dist" ]
