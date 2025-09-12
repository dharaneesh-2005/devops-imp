# Multi-stage Dockerfile for Node.js application
# Stage 1: Build stage
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --only=production && npm cache clean --force

# Stage 2: Production stage
FROM node:18-alpine AS production

# Create app user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Set working directory
WORKDIR /app

# Copy built dependencies from builder stage
COPY --from=builder /app/node_modules ./node_modules

# Copy application code
COPY --chown=nodejs:nodejs . .

# Explicitly copy public directory if it exists
COPY --chown=nodejs:nodejs public/ ./public/ 2>/dev/null || echo "No public directory to copy"

# Debug: Show what was copied
RUN echo "=== DEBUG: Directory contents ===" && \
    ls -la /app/ && \
    echo "=== DEBUG: Public directory ===" && \
    ls -la /app/public/ 2>/dev/null || echo "Public directory not found" && \
    echo "=== DEBUG: Check if index.html exists ===" && \
    ls -la /app/public/index.html 2>/dev/null || echo "index.html not found"

# Switch to non-root user
USER nodejs

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# Start application
CMD ["npm", "start"]
