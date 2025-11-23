# 🎮 Quick Start Guide - Eaglercraft Landing Page

## Start Everything

```bash
cd /home/rafa/gitee/eaglercraft-docker
docker compose up -d
```

## Access Points

- **Landing Page**: http://localhost
- **Minecraft Game**: http://localhost:5200

## Stop Everything

```bash
docker compose down
```

## View Logs

```bash
# Landing page logs
docker compose logs -f landing-page

# Game server logs
docker compose logs -f eaglercraft
```

## Rebuild After Changes

```bash
# Rebuild landing page
docker compose build landing-page

# Restart with new build
docker compose up -d --force-recreate landing-page
```

## File Locations

- **Landing Page**: `/home/rafa/gitee/eaglercraft-docker/landing-page/`
- **HTML**: `landing-page/index.html`
- **CSS**: `landing-page/style.css`
- **JS**: `landing-page/script.js`
- **Assets**: `landing-page/assets/`

## Quick Edits

### Change Your Name or Title

Edit `landing-page/index.html` around line 50

### Change Colors

Edit CSS variables in `landing-page/style.css` lines 1-30

### Update Links

Edit `landing-page/index.html`:

- GitHub link: line 62
- Portfolio link: line 197

## Troubleshooting

### Port 80 Already in Use

```bash
# Use different port (e.g., 8080)
# Edit docker-compose.yaml, change "80:80" to "8080:80"
```

### Container Won't Start

```bash
# Check logs
docker compose logs landing-page

# Rebuild from scratch
docker compose down
docker compose build --no-cache landing-page
docker compose up -d
```

### Changes Not Showing

```bash
# Force rebuild and recreate
docker compose up -d --build --force-recreate landing-page
```

## 🎨 Customization Tips

1. **Add New Section**: Copy existing section in HTML, update content
2. **Change Animation Speed**: Edit CSS animation durations
3. **Add More Blocks**: Duplicate `.floating-block` in CSS
4. **Change Font**: Update Google Fonts link in HTML head

Enjoy your Minecraft-themed DevOps landing page! 🚀
