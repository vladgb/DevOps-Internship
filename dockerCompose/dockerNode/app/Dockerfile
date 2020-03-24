FROM node:latest

#Create app directory
COPY app /app
WORKDIR /app

RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

EXPOSE 3000

ENTRYPOINT [ "node", "app.js" ]
