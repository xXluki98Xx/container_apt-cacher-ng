FROM ubuntu:24.04

LABEL maintainer="lramm.dev@gmail.com"

ENV APT_CACHER_NG_CACHE_DIR=/var/cache/apt-cacher-ng \
    APT_CACHER_NG_LOG_DIR=/var/log/apt-cacher-ng \
    APT_CACHER_NG_USER=apt-cacher-ng \
    APT_CACHER_NG_PORT=3142

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        ca-certificates wget curl less nano \
        apt-cacher-ng \
    && rm -rf /var/lib/apt/lists/*

COPY scripts/dist-* /mirror_scripts/
COPY scripts/update_conf.sh /update_conf.sh
COPY entrypoint.sh /entrypoint.sh

RUN cd /mirror_scripts; \
    mkdir -p /etc/apt-cacher-ng/mirror_list.d/; \
    chmod -R 0755 /etc/apt-cacher-ng/mirror_list.d/ \
    && chown -R ${APT_CACHER_NG_USER}:root /etc/apt-cacher-ng/mirror_list.d/; \
    cp /etc/apt-cacher-ng/acng.conf /etc/apt-cacher-ng/acng.conf.bak

RUN chmod 755 /entrypoint.sh

EXPOSE 3142/tcp

HEALTHCHECK --interval=10s --timeout=2s --retries=3 \
    CMD wget -q -t1 -O /dev/null http://localhost:3142/acng-report.html || exit 1

ENTRYPOINT ["/entrypoint.sh"]

CMD ["apt-cacher-ng"]
