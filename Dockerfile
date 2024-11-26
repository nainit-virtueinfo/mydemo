# Use Node.js 18-alpine as the base image
FROM node:18-alpine

# Set up environment variables
ENV DOMAIN="http://3.221.76.211:3000" \
    PORT=3000 \
    STATIC_DIR="./client" \
    PUBLISHABLE_KEY="pk_test_51L5AsSSCC8JVWfvgEtfJkzHMTh7Z5PLY5m1yhR379sJgwAVZEe13NaiG33wsHSyHnPJMjTNOosiPk6AeMI8q0ims0049IKffiu" \
    SECRET_KEY="sk_test_51L5AsSSCC8JVWfvgxpyZvQyBRRkHmGBkdyIa94vPD3Zs71qbHGrnSPlrJOIWiR74fbcn1A85yESCFnrrp3aX0Oz900JaunHrhe"

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose port 3000 for the container
EXPOSE 3000

# Start the application
CMD ["node", "server.js"]

