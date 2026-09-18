#
# firefox Dockerfile
#
# https://github.com/jlesage/docker-firefox
#

# Docker image version is provided via build arg.
ARG DOCKER_IMAGE_VERSION=

# Define software versions.
ARG FIREFOX_VERSION=151.0.3-r0
#ARG PROFILE_CLEANER_VERSION=2.36
ARG NSPR_VERSION=4.38.2

# Define software download URLs.
#ARG PROFILE_CLEANER_URL=https://github.com/graysky2/profile-cleaner/raw/v${PROFILE_CLEANER_VERSION}/common/profile-cleaner.in
ARG NSPR_URL=https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v${NSPR_VERSION}/src/nspr-${NSPR_VERSION}.tar.gz

# Get Dockerfile cross-compilation helpers.
FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

# Build the membarrier check tool.
FROM alpine:3.14 AS membarrier
WORKDIR /tmp
COPY membarrier_check.c .
RUN apk --no-cache add build-base linux-headers
RUN gcc -static -o membarrier_check membarrier_check.c
RUN strip membarrier_check

# Rebuild NSPR with 64-bit file offsets (Alpine's package caps PR_Seek64 at 2GiB on musl).
FROM --platform=$BUILDPLATFORM alpine:3.24 AS nspr
ARG TARGETPLATFORM
ARG NSPR_URL
COPY --from=xx / /
COPY src/nspr /build
RUN /build/build.sh "$NSPR_URL"
RUN xx-verify \
    /tmp/nspr-install/usr/lib/libnspr4.so \
    /tmp/nspr-install/usr/lib/libplc4.so \
    /tmp/nspr-install/usr/lib/libplds4.so

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.24-v4.14.0

ARG FIREFOX_VERSION
ARG DOCKER_IMAGE_VERSION

# Define working directory.
WORKDIR /tmp

# Install Firefox.
RUN \
#    add-pkg --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
#            --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
#            --upgrade firefox=${FIREFOX_VERSION}
     add-pkg firefox=${FIREFOX_VERSION}

# Install extra packages.
RUN \
    ARCH="$(apk --print-arch)" && \
    if [ "$ARCH" = "x86" ] || [ "$ARCH" = "x86_64" ]; then \
        libva_intel_driver="libva-intel-driver"; \
    fi && \
    add-pkg \
        # WebGL support.
        mesa-dri-gallium \
        mesa-va-gallium \
        $libva_intel_driver \
        # Audio support.
        libpulse \
        # Desktop notification support.
        libnotify \
        # Icons used by folder/file selection window (when saving as).
        adwaita-icon-theme \
        # The following package is used to send key presses to the X process.
        xdotool \
        # A font is needed.
        font-dejavu \
        && \
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
COPY --from=nspr /tmp/nspr-install/usr/lib/libnspr4.so* /usr/lib/
COPY --from=nspr /tmp/nspr-install/usr/lib/libplc4.so* /usr/lib/
COPY --from=nspr /tmp/nspr-install/usr/lib/libplds4.so* /usr/lib/

# Set internal environment variables.
RUN \
    set-cont-env APP_NAME "Firefox" && \
    set-cont-env APP_VERSION "$FIREFOX_VERSION" && \
    set-cont-env DOCKER_IMAGE_VERSION "$DOCKER_IMAGE_VERSION" && \
    true

# Set public environment variables.
ENV \
    FF_OPEN_URL= \
    FF_KIOSK=0 \
    FF_CUSTOM_ARGS=

# Metadata.
LABEL \
      org.label-schema.name="firefox" \
      org.label-schema.description="Docker container for Firefox" \
      org.label-schema.version="${DOCKER_IMAGE_VERSION:-unknown}" \
      org.label-schema.vcs-url="https://github.com/jlesage/docker-firefox" \
      org.label-schema.schema-version="1.0"
