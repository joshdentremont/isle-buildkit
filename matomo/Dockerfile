# syntax=docker/dockerfile:1.2.1
ARG repository=local
ARG tag=latest
FROM --platform=$BUILDPLATFORM ${repository}/download:${tag} AS download

ARG MATOMO_VERSION="4.12.3"
ARG MATOMO_FILE_SHA256="00efe4335c9cee9f269b5e8a337026af7f115c05cde1e9ae47485592372b37ee"

RUN --mount=type=cache,id=matomo-downloads,sharing=locked,target=/opt/downloads \
    MATOMO_FILE="matomo-${MATOMO_VERSION}.tar.gz" && \
    MATOMO_URL="https://builds.matomo.org/${MATOMO_FILE}" && \
    download.sh --url "${MATOMO_URL}" --sha256 "${MATOMO_FILE_SHA256}" "${DOWNLOAD_CACHE_DIRECTORY}" && \
    tar -xzf "${DOWNLOAD_CACHE_DIRECTORY}/${MATOMO_FILE}" -C /opt && \
    rm "/opt/How to install Matomo.html"

FROM ${repository}/nginx:${tag}

EXPOSE 8000

# The driver is given explicitly to prevent accidentially overriding as Matomo
# only supports MySQL.
ENV \
    MATOMO_ASSUME_SECURE_PROTOCOL=1 \
    MATOMO_DB_DRIVER=mysql \
    MATOMO_DB_NAME=matomo \
    MATOMO_DB_PASSWORD=password \
    MATOMO_DB_USER=matomo \
    MATOMO_DEFAULT_HOST=https://islandora.traefik.me \
    MATOMO_DEFAULT_NAME=Islandora \
    MATOMO_DEFAULT_TIMEZONE=America/Halifax \
    MATOMO_FORCE_SSL=1 \
    MATOMO_PROXY_CLIENT_HEADERS=HTTP_X_FORWARDED_FOR \
    MATOMO_PROXY_HOST_HEADERS=HTTP_X_FORWARDED_HOST \
    MATOMO_PROXY_URI_HEADER=1 \
    MATOMO_SALT=5a472390550bd59e4428a41aa472137b \
    MATOMO_USER_EMAIL=admin@example.org \
    MATOMO_USER_NAME=admin \
    MATOMO_USER_PASS='$2y$10$S38e7HPM9LI3aOIvcnRsfuMCm4ipNP572QsvbCK60upoHVJ61hMrS'

COPY --from=download --chown=nginx:nginx /opt/matomo /var/www/matomo

COPY rootfs /

WORKDIR /var/www/matomo
