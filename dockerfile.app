# Example for Node.js app
FROM node:18-alpine

WORKDIR /app

# Copy package.json first (for caching)
COPY package*.json ./

RUN npm install --only=production

COPY . .

EXPOSE 80
CMD ["npm", "start"]
