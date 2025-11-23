# Usamos Eclipse Temurin con Java 8 (basado en Ubuntu/Debian)
# Java 8 es lo recomendado para servidores Minecraft 1.8
FROM eclipse-temurin:8-jre

# Actualizar repositorios e instalar dependencias necesarias
# python3: para el servidor http simple
# tmux: para gestionar la consola del servidor
RUN apt-get update && apt-get install -y \
    python3 \
    tmux \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Verificar versiones instaladas
RUN java -version && python3 --version && tmux -V
COPY . /eaglerX-1.8-server
WORKDIR /eaglerX-1.8-server

ENV TERM xterm-256color
ENTRYPOINT ["/eaglerX-1.8-server/script/start_server.sh"]
