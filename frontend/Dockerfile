# Use the official Node.js LTS image as the base image
FROM node:16 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package.json ./

# Install dependencies
RUN npm i

# Copy the rest of the application files to the container
COPY . .

# Expose port 80 to the host
EXPOSE 3000

# Start the React app
CMD ["npm", "start"]
