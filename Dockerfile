# Use an official Nginx image as the base
FROM nginx:alpine

# Copy static files to the default Nginx public directory
COPY . /usr/share/nginx/html/

# Expose port 80 for the web server
EXPOSE 80
