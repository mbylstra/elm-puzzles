FROM node:7.2.0

MAINTAINER Michael Bylstra <mbylstra@gmail.com>

RUN npm install -g elm@0.18.0

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm install --only=production

# this will bake in the initial elm std libraries
RUN elm make --yes

# Bundle app source
COPY . .

EXPOSE 8080
CMD [ "npm", "start" ]
