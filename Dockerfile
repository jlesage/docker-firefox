#
# Camoufox + Playwright Dockerfile
#
# https://github.com/batrapvd/docker-camoufox-playwright
#

# Build the membarrier check tool.
FROM alpine:3.14 AS membarrier
WORKDIR /tmp
COPY membarrier_check.c .
RUN apk --no-cache add build-base linux-headers
RUN gcc -static -o membarrier_check membarrier_check.c
RUN strip membarrier_check

# Pull base image.
FROM jlesage/baseimage-gui:debian-12-v4.9.0

# Docker image version is provided via build arg.
ARG DOCKER_IMAGE_VERSION=

# Define software versions.
ARG CAMOUFOX_PYPI_VERSION=0.4.11
#ARG PROFILE_CLEANER_VERSION=2.36

# Define software download URLs.
#ARG PROFILE_CLEANER_URL=https://github.com/graysky2/profile-cleaner/raw/v${PROFILE_CLEANER_VERSION}/common/profile-cleaner.in

# Define working directory.
WORKDIR /tmp

# Avoid interactive prompts from apt.
ARG DEBIAN_FRONTEND=noninteractive

# Install system dependencies.
RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
    && \
    rm -rf /var/lib/apt/lists/*

# Install Camoufox and Playwright runtime.
ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PLAYWRIGHT_BROWSERS_PATH=/usr/lib/playwright \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_BREAK_SYSTEM_PACKAGES=1

RUN \
    mkdir -p "$PLAYWRIGHT_BROWSERS_PATH" && \
    python3 -m pip install --no-cache-dir --break-system-packages --upgrade pip && \
    python3 -m pip install --no-cache-dir --break-system-packages camoufox==${CAMOUFOX_PYPI_VERSION} && \
    python3 -m playwright install && \
    # Pre-fetch Camoufox browser for the build architecture to speed up first run.
    # If this fails (no network during build), runtime will fetch it.
    python3 -m camoufox fetch || true && \
    # Allow runtime user to fetch Browserforge models on first start.
    chmod -R a+rwX /usr/local/lib/python3.11/dist-packages/browserforge || true && \
    rm -rf /root/.cache/pip

# Install extra packages.
RUN \
    apt-get update && \
    # WebGL support, audio, icons, fonts, and automation helpers.
    apt-get install -y --no-install-recommends \
        libgtk-3-0 \
        libgl1-mesa-dri \
        libasound2 \
        libpulse0 \
        adwaita-icon-theme \
        fonts-dejavu-core \
        xdotool \
    && \
    rm -rf /var/lib/apt/lists/* && \
    # Remove unneeded icons.
    find /usr/share/icons/Adwaita -type d -mindepth 1 -maxdepth 1 -not -name 16x16 -not -name scalable -exec rm -rf {} ';' && \
    true

# Install profile-cleaner.
#RUN \
#    add-pkg --virtual build-dependencies curl && \
#    curl -# -L -o /usr/bin/profile-cleaner {$PROFILE_CLEANER_URL} && \
#    sed-patch 's/@VERSION@/'${PROFILE_CLEANER_VERSION}'/' /usr/bin/profile-cleaner && \
#    chmod +x /usr/bin/profile-cleaner && \
#    add-pkg \
#        bash \
#        file \
#        coreutils \
#        bc \
#        parallel \
#        sqlite \
#        && \
#    # Cleanup.
#    del-pkg build-dependencies && \
#    rm -rf /tmp/* /tmp/.[!.]*

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://github.com/jlesage/docker-templates/raw/master/jlesage/images/firefox-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /
COPY --from=membarrier /tmp/membarrier_check /usr/bin/

# Ensure init scripts are executable
RUN chmod -R a+rx /etc/cont-init.d || true

# Set internal environment variables.
RUN \
    set-cont-env APP_NAME "Camoufox" && \
    set-cont-env APP_VERSION "$CAMOUFOX_PYPI_VERSION" && \
    set-cont-env DOCKER_IMAGE_VERSION "$DOCKER_IMAGE_VERSION" && \
    true

# Set public environment variables.
ENV \
    FF_OPEN_URL= \
    FF_KIOSK=0 \
    FF_CUSTOM_ARGS=

# Metadata.
LABEL \
      org.label-schema.name="camoufox" \
      org.label-schema.description="Docker container for Camoufox" \
      org.label-schema.version="${DOCKER_IMAGE_VERSION:-unknown}" \
      org.label-schema.vcs-url="https://github.com/batrapvd/docker-camoufox-playwright" \
      org.label-schema.schema-version="1.0"
