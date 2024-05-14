sudo docker run -d --restart always cloudflare/cloudflared:latest tunnel run --token xxx
