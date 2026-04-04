#!/bin/bash

echo "🚀 Starting setup..."

# Update system

sudo apt update -y

# Install Node.js (LTS)

curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Install Nginx

sudo apt install -y nginx

# Install PM2 globally

sudo npm install -g pm2

# Go to project root

cd ~/interview_ai || exit

# Pull latest code

echo "📦 Pulling latest code..."
git pull origin main

# Install Backend dependencies

echo "📦 Installing Backend deps..."
cd Backend || exit
npm install

# Install Frontend dependencies

echo "📦 Installing Frontend deps..."
cd ../Frontend || exit
npm install

# Configure Nginx

echo "⚙️ Configuring Nginx..."

sudo bash -c 'cat > /etc/nginx/sites-available/default << "EOF"
server {
listen 80;
server_name _;

```
root /var/www/html;
index index.html;

location / {
    try_files \$uri /index.html;
}

location /api/ {
    proxy_pass http://localhost:3000/;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host \$host;
}
```

}
EOF'

# Restart Nginx

sudo systemctl restart nginx

echo "✅ Setup completed!"