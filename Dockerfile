# Build Angular
FROM node:18 AS build-frontend
WORKDIR /app
COPY frontend/package*.json frontend/
RUN cd frontend && npm ci
COPY frontend frontend
RUN cd frontend && npm run build -- --output-path=dist/frontend --configuration production

# Run with Node
FROM node:18-slim
WORKDIR /app
COPY server/package*.json server/
RUN cd server && npm ci --only=production
COPY server server/
COPY --from=build-frontend /app/frontend/dist/frontend frontend/dist/frontend
EXPOSE 8080
CMD ["node", "server/index.js"]
