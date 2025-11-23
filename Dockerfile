FROM node:20-alpine

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    git \
    curl \
    bash

# Install Claude Code CLI (example - adjust based on actual installation method)
RUN npm install -g @anthropic-ai/claude-code

# Copy application files
COPY package*.json ./
RUN npm ci --only=production

COPY . .

# Create non-root user
RUN addgroup -g 1001 -S claude && \
    adduser -S claude -u 1001 && \
    chown -R claude:claude /app

USER claude

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "console.log('healthy')" || exit 1

# Default command
CMD ["node", "index.js"]
