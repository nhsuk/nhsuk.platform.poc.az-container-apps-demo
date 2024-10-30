# Dockerfile
FROM nginx:alpine
LABEL maintainer="yourname@example.com"

# Copy the HTML file to the default location Nginx uses to serve content
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80 to access the server
EXPOSE 80

# Run Nginx in the foreground to keep the container running
CMD ["nginx", "-g", "daemon off;"]
