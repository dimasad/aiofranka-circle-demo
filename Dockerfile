FROM docker.io/library/python:3.12

# Install git
RUN apt-get update && apt-get install -y git && \
  rm -rf /var/lib/apt/lists/*

# Install aiofranka
RUN cd /tmp/ && \
  git clone https://github.com/Improbable-AI/aiofranka.git && \
  cd aiofranka && \
  pip --no-cache-dir install pylibfranka==0.17.0 && \
  pip --no-cache-dir install . && \
  rm -rf /tmp/aiofranka
