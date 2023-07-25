# Use the official Node.js LTS image as the base image
FROM node:16

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package.json ./

# Install dependencies
RUN npm i

# Copy the rest of the backend application files to the container
COPY . .

# Expose port 3002 to the host
EXPOSE 3001

# Start the Node.js application
CMD ["npm", "start"]
