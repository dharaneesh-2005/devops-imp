# Docker Learning Guide

## Phase 1: Docker Containerization

### What You'll Learn
- Containerization concepts
- Docker fundamentals
- Multi-stage builds
- Docker Compose
- Best practices

### Step 1: Understanding Containers

**What are containers?**
- Lightweight, portable units that package applications and their dependencies
- Share the host OS kernel
- Isolated from each other
- Consistent across different environments

**Benefits:**
- Consistency: "Works on my machine" problem solved
- Portability: Run anywhere Docker runs
- Scalability: Easy to scale up/down
- Resource efficiency: Less overhead than VMs

### Step 2: Docker Basics

**Key Concepts:**
- **Image**: Read-only template with instructions to create a container
- **Container**: Running instance of an image
- **Dockerfile**: Text file with instructions to build an image
- **Registry**: Storage and distribution system for images

**Essential Commands:**
```bash
# Build an image
docker build -t my-app .

# Run a container
docker run -p 3000:3000 my-app

# List running containers
docker ps

# List all containers
docker ps -a

# List images
docker images

# Stop a container
docker stop <container-id>

# Remove a container
docker rm <container-id>

# Remove an image
docker rmi <image-id>

# View container logs
docker logs <container-id>

# Execute commands in running container
docker exec -it <container-id> /bin/sh
```

### Step 3: Understanding Our Dockerfile

Let's break down the Dockerfile we created:

```dockerfile
# Multi-stage build - reduces final image size
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

FROM node:18-alpine AS production
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --chown=nodejs:nodejs . .
USER nodejs
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"
CMD ["npm", "start"]
```

**Key Features:**
1. **Multi-stage build**: Separates build and runtime environments
2. **Alpine Linux**: Minimal base image for smaller size
3. **Non-root user**: Security best practice
4. **Health check**: Monitors application health
5. **Layer optimization**: Efficient caching

### Step 4: Hands-on Exercises

**Exercise 1: Build and Run Locally**
```bash
# Navigate to the app directory
cd src/app

# Install dependencies
npm install

# Build the Docker image
docker build -f ../../docker/Dockerfile -t devops-app .

# Run the container
docker run -p 3000:3000 devops-app

# Test the application
curl http://localhost:3000/health
```

**Exercise 2: Using Docker Compose**
```bash
# Navigate to docker directory
cd docker

# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

**Exercise 3: Image Optimization**
1. Compare image sizes before and after optimization
2. Use `docker history` to analyze layers
3. Experiment with different base images

### Step 5: Best Practices

**Security:**
- Use non-root users
- Keep base images updated
- Scan images for vulnerabilities
- Use minimal base images (Alpine)

**Performance:**
- Use multi-stage builds
- Leverage layer caching
- Use .dockerignore
- Optimize layer order

**Maintenance:**
- Tag images properly
- Use specific versions
- Document your Dockerfiles
- Regular security updates

### Step 6: Testing Your Setup

**Health Check:**
```bash
# Check if container is healthy
docker ps

# Test health endpoint
curl http://localhost:3000/health

# View container logs
docker logs <container-id>
```

**Load Testing:**
```bash
# Install Apache Bench (if available)
ab -n 100 -c 10 http://localhost:3000/api
```

### Next Steps

Once you're comfortable with Docker:
1. Experiment with different base images
2. Try building multi-service applications
3. Learn about Docker networking
4. Explore Docker volumes and data persistence
5. Move to Phase 2: Terraform and AWS

### Troubleshooting

**Common Issues:**
- Port conflicts: Use different ports or stop conflicting services
- Permission issues: Check file ownership and Docker daemon permissions
- Build failures: Check Dockerfile syntax and dependencies
- Container won't start: Check logs with `docker logs <container-id>`

**Useful Commands:**
```bash
# Clean up unused resources
docker system prune

# Remove all stopped containers
docker container prune

# Remove unused images
docker image prune

# View Docker system info
docker system df
```
