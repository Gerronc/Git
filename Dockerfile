 # Start with a lightweight web server
FROM nginx:alpine

# Remove the default Nginx web page
RUN rm -rf /usr/share/nginx/html/*

# Copy your site files into Nginx web directory
COPY . /usr/share/nginx/html

# Expose port 80 to the outside
EXPOSE 80

# Start Nginx when container starts
CMD ["nginx", "-g", "daemon off;"]
