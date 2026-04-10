FROM node:20-alpine

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm install

COPY . .

EXPOSE 3000

# Install deps into the volume mount at runtime, then start dev server
CMD sh -c "npm install && npm run dev"
