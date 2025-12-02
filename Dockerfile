# Build Angular
FROM node:18 AS build-frontend
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm ci
COPY frontend ./
RUN npm run build -- --output-path=dist/frontend --configuration production

# Run with Node
FROM node:18-slim
WORKDIR /app
COPY server/package*.json ./
RUN npm ci --only=production
COPY server ./
COPY --from=build-frontend /app/frontend/dist/frontend ./frontend/dist/frontend
EXPOSE 8080
CMD ["node", "index.js"]
