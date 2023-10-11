# Stage 1: Build the Angular App
FROM node:latest as build

WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install app dependencies
RUN npm install

# Copy app source code
COPY . .

# Build the Angular app with production configuration
RUN npm run build

# Stage 2: Serve the Angular App with NGINX
FROM nginx:alpine

# Copy the compiled app from the build stage to NGINX's HTML directory
COPY --from=build /app/dist/ /usr/share/nginx/html


# Expose port 80 (default for HTTP)
EXPOSE 80

# Start NGINX when the container runs
CMD ["nginx", "-g", "daemon off;"]

