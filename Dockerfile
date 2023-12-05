#chose image
FROM node:14
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . . 
# copy all files from current dir to /app dir in container
EXPOSE 3000 
# chose the listen port
CMD ["node", "index.js"]
# run command node index.js to start
