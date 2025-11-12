FROM node:current-alpine3.21
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
CMD node /app/app.js
EXPOSE 8080
