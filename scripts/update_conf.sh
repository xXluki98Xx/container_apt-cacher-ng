#!/bin/bash

# sed "s@@@" -i "$acngConf"
# sed "@^test.*@a ersetzung" -i "$acngConf"

acngConf="/etc/apt-cacher-ng/acng.conf"

sed "s#CacheDir: /var/cache/apt-cacher-ng#CacheDir: ${APT_CACHER_NG_CACHE_DIR}#" -i "$acngConf"
sed "s#LogDir: /var/log/apt-cacher-ng#LogDir: ${APT_CACHER_NG_LOG_DIR}#" -i "$acngConf"

# Setup Config
sed "s@# Port:3142@Port: ${APT_CACHER_NG_PORT}@" -i "$acngConf"
sed "s@# VerboseLog: 1@VerboseLog: 1@" -i "$acngConf"
sed "s@# ForeGround: 0@ForeGround: 1@" -i "$acngConf"
sed "s@# PidFile: /var/run/apt-cacher-ng/pid@PidFile: /var/run/apt-cacher-ng/pid@" -i "$acngConf"
sed 's@# VfilePatternEx:@VfilePatternEx: ^(\\/mirrorlist\\/.*|mirrors\\/.*|/\\?release=[0-9]+\&arch=.*|.*\\/RPM-GPG-KEY.*)\$@' -i "$acngConf"
sed "s@# PrecacheFor: debrep@PrecacheFor: debrep@" -i "$acngConf"

sed "/^# BindAddress: localhost/a BindAddress: 0.0.0.0" -i "$acngConf"
sed "/^# DontCache: .*.local.university.int/a DontCache: mirrorlist\\\.centos.org|mirrors\\\.(almalinux|fedoraproject)\\\.org|(\/mirrorlist\/)|(.bz2\$)" -i "$acngConf"
sed "/^# PassThroughPattern: \^(bugs/a PassThroughPattern: \^(bugs\\\.debian\\\.org|changelogs\\\.ubuntu\\\.com|mirrors\\\.(almalinux|fedoraproject)\\\.org|.*\\\.(docker|gcr|ghcr|quay)\\\.(io|com):443)\$" -i "$acngConf"


# Setup Mirrors
sed "s@Remap-sfnet@# Remap-sfnet@" -i "$acngConf"
sed "s@Remap-alxrep@# Remap-alxrep@" -i "$acngConf"

sed "s@file:fedora_mirrors@file:/etc/apt-cacher-ng/mirror_list.d/list.fedora /fedora@" -i "$acngConf"
sed "s@file:epel_mirrors@file:/etc/apt-cacher-ng/mirror_list.d/list.fedora-epel /fedora-epel@" -i "$acngConf"

sed "/^Remap-epel:/a Remap-centos-stream: file:\/etc\/apt-cacher-ng\/mirror_list.d/list.centos \/centos-stream # CentOS Stream Linux" -i "$acngConf"
sed "/^Remap-epel:/a Remap-centos: file:\/etc\/apt-cacher-ng\/mirror_list.d\/list.centos \/centos # CentOS Linux" -i "$acngConf"
sed "/^Remap-epel:/a Remap-alma: file:\/etc\/apt-cacher-ng\/mirror_list.d\/list.alma \/almalinux # Alma Linux" -i "$acngConf"