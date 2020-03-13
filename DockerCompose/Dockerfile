FROM node:13

WORKDIR /app

COPY ./node-chat /app

RUN npm install

ENTRYPOINT ["node", "app.js"]

EXPOSE 3000
