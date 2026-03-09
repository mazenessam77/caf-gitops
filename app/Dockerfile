# ---------- Stage 1: Build ----------
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

# ---------- Stage 2: Production ----------
FROM node:20-alpine
RUN addgroup -S caf && adduser -S caf -G caf
WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY . .

USER caf
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "server.js"]
