FROM docker.io/library/python:3.12

# Build-time proxy config. Pass via:
#   podman build --network=host \
#     --build-arg HTTPS_PROXY=http://127.0.0.1:41383 \
#     --build-arg NO_PROXY=pypi.org,files.pythonhosted.org ...
# HTTPS_PROXY lets git reach GitHub through the egress proxy.
# NO_PROXY bypasses it for PyPI so pip connects directly.
ARG HTTPS_PROXY
ARG https_proxy
ARG NO_PROXY
ARG no_proxy

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

# Trust the build-time proxy CA (passed in via --secret or COPY at build time).
# The host ca-bundle is COPY'd as a build arg so the container can reach PyPI
# and GitHub through the egress proxy during image construction.
ARG CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
COPY ca-bundle.crt /usr/local/share/ca-certificates/proxy-ca.crt
RUN update-ca-certificates
ENV GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
ENV PIP_CERT=/etc/ssl/certs/ca-certificates.crt
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

# Install aiofranka from a pre-patched wheel (patched for MuJoCo 3.x API:
# mj_fullM signature changed from (model, dst, qM) to (model, data, dst)).
COPY aiofranka-0.3.0-py3-none-any.whl /tmp/
RUN pip --no-cache-dir install /tmp/aiofranka-0.3.0-py3-none-any.whl && \
    rm /tmp/aiofranka-0.3.0-py3-none-any.whl

# Point MuJoCo's GLFW at the virtual display started by docker-compose.
ENV DISPLAY=:99
