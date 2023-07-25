# Use the official Node.js LTS image as the base image
FROM node:lts

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the backend application files to the container
COPY . .

# Expose port 5000 to the host
EXPOSE 5000

# Start the Node.js application
CMD ["npm", "start"]
