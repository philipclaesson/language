# Single-stage image: install deps, build the SPA, run the Hono server with tsx.
# Image size isn't a concern at this scale; this keeps the build dead simple.
FROM node:22-slim

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

ENV NODE_ENV=production
ENV PORT=8080
EXPOSE 8080

CMD ["npx", "tsx", "server/index.ts"]
