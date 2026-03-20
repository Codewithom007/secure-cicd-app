#!/bin/bash
# Deployment script — runs on target EC2 server via SSH
# Usage: ./deploy.sh <environment> <version>
set -e   # Stop if any command fails
 
ENVIRONMENT=$1
VERSION=$2
APP_DIR=/var/www/app
REPO_URL=https://github.com/YOUR-USERNAME/secure-cicd-app.git
 
echo "=== Deploying $VERSION to $ENVIRONMENT ==="
 
# Stop existing app gracefully
pm2 stop cicd-app 2>/dev/null || true
 
# Get latest code
if [ -d "$APP_DIR/.git" ]; then
  cd $APP_DIR && git fetch origin && git reset --hard origin/main
else
  git clone $REPO_URL $APP_DIR && cd $APP_DIR
fi
 
# Install production dependencies only
npm ci --only=production
 
# Start app with PM2
NODE_ENV=$ENVIRONMENT APP_VERSION=$VERSION PORT=3000 \
  pm2 start server.js --name cicd-app --update-env
pm2 save
 
# Wait for app to initialize
sleep 3
 
# Health check
if curl -sf http://localhost:3000/health | grep -q OK; then
  echo "=== DEPLOYMENT SUCCESS: $ENVIRONMENT is healthy ==="
  exit 0
else
  echo '=== DEPLOYMENT FAILED: health check returned no OK ==='
  pm2 logs cicd-app --lines 30
  exit 1
fi
