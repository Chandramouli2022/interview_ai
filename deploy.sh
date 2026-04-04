#!/bin/bash

echo "🚀 Starting deployment..."

cd ~/interview_ai || exit

# Build Frontend

echo "🏗️ Building frontend..."
cd Frontend || exit
npm run build

# Copy build to Nginx

echo "📁 Moving build to Nginx..."
sudo rm -rf /var/www/html/*
sudo cp -r dist/* /var/www/html/

# Start Backend with PM2

echo "⚙️ Starting backend..."

cd ../Backend || exit

pm2 delete interview-ai-backend 2>/dev/null
pm2 start src/index.js --name interview-ai-backend

pm2 save

echo "✅ Deployment completed!"
