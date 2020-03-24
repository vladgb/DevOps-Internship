FROM centos:8

#Create app directory
COPY app /app
WORKDIR /app

RUN dnf install -y nodejs npm
RUN npm install
#RUN dnf install nohup 

EXPOSE 3000

ENTRYPOINT [ "nohup" , "node" , "app.js" ]
