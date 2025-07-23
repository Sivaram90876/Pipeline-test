# Use a base image (e.g., official Node.js image)
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (if using npm)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of your application code
COPY . .

# Expose the port your app listens on (if applicable)
EXPOSE 3000

# Command to run your application when the container starts
CMD ["npm", "start"]
