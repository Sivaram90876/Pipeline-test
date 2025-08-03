# Use Nginx base image
FROM nginx:alpine

# Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy website files to nginx html directory
COPY . /usr/share/nginx/html

# Expose port 80 for the container
EXPOSE 80

# Nginx will run automatically
