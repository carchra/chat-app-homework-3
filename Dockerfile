FROM httpd:2.4
COPY . /usr/local/apache2/htdocs/
CMD node /app/app.js
EXPOSE 8080
