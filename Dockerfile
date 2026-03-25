
FROM nginx:latest

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

COPY build/ /usr/share/nginx/html/


EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
