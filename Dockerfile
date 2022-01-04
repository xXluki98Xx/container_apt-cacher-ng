FROM alpine/git AS git

RUN git clone https://github.com/xXluki98Xx/container_apt-cacher-ng /app/swap

# -----

FROM ubuntu:rolling

LABEL maintainer="lramm.dev@gmail.com"

ENV APT_CACHER_NG_VERSION=3.3 \
    APT_CACHER_NG_CACHE_DIR=/var/cache/apt-cacher-ng \
    APT_CACHER_NG_LOG_DIR=/var/log/apt-cacher-ng \
    APT_CACHER_NG_USER=apt-cacher-ng \
    APT_CACHER_NG_PORT=3142

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        apt-cacher-ng ca-certificates wget curl less nano \
    && rm -rf /var/lib/apt/lists/*

COPY --from=git /app/swap/scripts/dist-* /mirror_scripts/
COPY --from=git /app/swap/scripts/update_conf.sh /update_conf.sh
COPY --from=git /app/swap/entrypoint.sh /sbin/entrypoint.sh
# COPY scripts/update_conf.sh /update_conf.sh

RUN cd /mirror_scripts; \
    mkdir -p /etc/apt-cacher-ng/mirror_list.d/; \
    chmod -R 0755 /etc/apt-cacher-ng/mirror_list.d/ \
    && chown -R ${APT_CACHER_NG_USER}:root /etc/apt-cacher-ng/mirror_list.d/; \
    cp /etc/apt-cacher-ng/acng.conf /etc/apt-cacher-ng/acng.conf.bak

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3142/tcp

HEALTHCHECK --interval=10s --timeout=2s --retries=3 \
    CMD wget -q -t1 -O /dev/null http://localhost:3142/acng-report.html || exit 1

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/apt-cacher-ng"]
