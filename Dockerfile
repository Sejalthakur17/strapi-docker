
# Build stage

FROM node:20-alpine AS builder

WORKDIR /app

# Needed for native dependencies (sqlite, sharp, etc.)
RUN apk add --no-cache python3 make g++

# Copy dependency files
COPY package.json package-lock.json ./

# Install dependencies (npm ci breaks with Strapi 5)
RUN npm install

# Copy application source
COPY . .

# Build Strapi admin
RUN npm run build

# Production stage

FROM node:20-alpine

ENV NODE_ENV=production
WORKDIR /app

# Copy everything from builder (including node_modules)
COPY --from=builder /app ./

EXPOSE 1337

CMD ["npm", "run", "start"]
