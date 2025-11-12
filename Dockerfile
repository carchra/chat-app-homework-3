FROM node:current-alpine3.21
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3700
CMD ['node', 'index.js']
