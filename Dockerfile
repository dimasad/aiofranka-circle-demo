FROM docker.io/library/python:3.12

# System deps: git for aiofranka install; X11/Mesa/Xvfb so MuJoCo's GLFW
# viewer works headlessly in a container via a virtual framebuffer.
RUN apt-get update && apt-get install -y \
    git \
    xvfb \
    libgl1 \
    libglu1-mesa \
    libx11-6 \
    libxrandr2 \
    libxinerama1 \
    libxcursor1 \
    libxi6 \
    libxxf86vm1 \
  && rm -rf /var/lib/apt/lists/*

# Install aiofranka
RUN cd /tmp/ && \
  git clone https://github.com/Improbable-AI/aiofranka.git && \
  cd aiofranka && \
  pip --no-cache-dir install . && \
  rm -rf /tmp/aiofranka

# Point MuJoCo's GLFW at the virtual display started by docker-compose.
ENV DISPLAY=:99
