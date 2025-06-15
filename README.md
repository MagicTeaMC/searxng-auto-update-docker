# searxng-auto-update-docker
Update my SearXNG instance automatically
## Setup
Edit `compose.yml` and `update-searxng.sh` as your want (You need to edit it or it won't work).  
Run `crontab -l` then add `0 2 * * * /home/changeme/searxng/update-searxng.sh` (don't forgot to edit it) to the end of the lines.  
Done! Now your SearXNG instance will follow the latest updates!
