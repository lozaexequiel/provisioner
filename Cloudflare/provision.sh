#!/bin/bash
#set -x

install_cloudflarecli ()
{
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflared.list
sudo apt-get update 
sudo apt-get install cloudflared -y
}

clean_up ()
{
apt autoremove -y
apt clean
}

install_cloudflarecli
clean_up