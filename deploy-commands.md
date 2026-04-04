
use this to connect to server

ssh -i C:\Users\chand\.ssh\phani-ec2-key.pem ubuntu@13.60.253.105 


Got it — you want **2 simple `.sh` scripts** to fully automate your EC2 deployment.
I’ll give you **clean, production-ready scripts** 👇

---

# 🧩 Script 1: `setup.sh`

👉 Does:

* Pull latest code
* Install Node + Nginx + PM2
* Install dependencies (frontend + backend)
* Configure Nginx

---

#!/bin/bash

echo "🚀 Starting setup..."

# Update system

sudo apt update -y

# Install Node.js (LTS)

curl -fsSL [https://deb.nodesource.com/setup_lts.x](https://deb.nodesource.com/setup_lts.x) | sudo -E bash -
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

---

# 🧩 Script 2: `deploy.sh`

👉 Does:

* Build frontend
* Move build to Nginx
* Restart backend using PM2

---

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

---

# 🧪 How to use

### 1. Create files

```bash
nano setup.sh
nano deploy.sh
```

Paste scripts → save

---

### 2. Give permissions

```bash
chmod +x setup.sh deploy.sh
```

---

### 3. Run (first time)

```bash
./setup.sh
```

---

### 4. Deploy anytime

```bash
./deploy.sh
```

---

# 🔥 What you achieved

* 1 command → full server setup
* 1 command → deploy latest code
* No manual Nginx / PM2 work

---

# ⚠️ Optional improvements (tell me if you want)

* Add `.env` auto setup
* Add domain + SSL (HTTPS 🔒)
* Add GitHub webhook (auto deploy on push 🚀)
* Zero downtime deploy

---

If you want, I can compress this into **single script + CI/CD pipeline** next 👍
