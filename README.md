# Eaglercraft Docker Project

Play Minecraft 1.12 in your browser with a beautiful landing page!

## 🎮 Features

- **Beautiful Landing Page**: Minecraft-themed landing page showcasing DevOps skills
- **Browser-Based Minecraft**: Play Minecraft 1.12 directly in your browser
- **Docker Containerized**: Easy deployment with Docker Compose
- **Separate Services**: Landing page and game server run in separate containers

## 🚀 Quick Start

### Prerequisites

- Docker
- Docker Compose

### Setup

1. Clone this repository:

```bash
git clone <repository-url>
cd eaglercraft-docker
```

2. Build and start the containers:

```bash
docker-compose build
docker-compose up -d
```

3. Access the services:
   - **Landing Page**: http://localhost
   - **Minecraft Game**: http://localhost:5200 (or click "Play Minecraft" on the landing page)

### Stopping the Services

```bash
docker-compose down
```

## 📦 Services

### Landing Page (`landing-page`)

- **Port**: 80
- **Container**: `eaglercraft-landing`
- **Technology**: Nginx serving static HTML/CSS/JS
- **Features**:
  - Minecraft-themed design
  - DevOps portfolio presentation
  - Links to GitHub and personal website
  - Responsive design with animations

### Eaglercraft Server (`eaglercraft`)

- **Ports**: 5200, 5201
- **Container**: `eaglercraft-server`
- **Technology**: Minecraft 1.12 server optimized for browser play
- **Data Persistence**: World data stored in volumes

## 🎨 Customization

### Landing Page

Edit the following files in `landing-page/`:

- `index.html` - Structure and content
- `style.css` - Styling and animations
- `script.js` - Interactive features
- `assets/` - Images and media

### Server Configuration

- Port configuration: Edit `bungee/plugins/EaglercraftXBungee/listeners.yml`
- Server settings: Edit files in `server/` directory

## 🌐 Network Configuration

Both services are connected via a Docker bridge network (`eaglercraft-network`) for internal communication.

## 📝 Notes

1. The landing page serves as the entry point on port 80
2. The game server runs on ports 5200 (WebSocket) and 5201 (HTTP)
3. World data is persisted in Docker volumes
4. Default configuration uses port 5200 (not 25565 from older versions)

## 🔗 Links

- **GitHub**: https://github.com/insanerask77
- **Portfolio**: https://rafa.madolell.com

## 📚 Original Credits

- Eaglercraft and EaglercraftX: lax1dude (Calder Young)
- Eaglercraft Server: ayunami2000
- Fork from: https://github.com/burgerhugger/ALL-server

## 🛠️ Deployment Order

When deploying, start services in this order:

1. Bungee server
2. Main server

The docker-compose configuration handles this automatically.

---

**Built with ❤️ by Rafa Madolell | DevOps & Cloud Engineer**
