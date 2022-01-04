#!/bin/bash
set -e

curDir=$PWD
acngConf="/etc/apt-cacher-ng/acng.conf"

create_pid_dir() {
  mkdir -p /run/apt-cacher-ng
  chmod -R 0755 /run/apt-cacher-ng
  chown ${APT_CACHER_NG_USER}:${APT_CACHER_NG_USER} /run/apt-cacher-ng
}

create_cache_dir() {
  mkdir -p ${APT_CACHER_NG_CACHE_DIR}
  chmod -R 0755 ${APT_CACHER_NG_CACHE_DIR}
  chown -R ${APT_CACHER_NG_USER}:root ${APT_CACHER_NG_CACHE_DIR}
}

create_log_dir() {
  mkdir -p ${APT_CACHER_NG_LOG_DIR}
  chmod -R 0755 ${APT_CACHER_NG_LOG_DIR}
  chown -R ${APT_CACHER_NG_USER}:${APT_CACHER_NG_USER} ${APT_CACHER_NG_LOG_DIR}
}

mirror_lists(){
  scriptDir='mirror_scripts'
  mirrorDir='/etc/apt-cacher-ng/mirror_list.d/'

  if [ -z "$(ls -A /etc/apt-cacher-ng/mirror_list.d)" ]; then
    echo "mirror lists doesnt exist, will created"

    cd "/$scriptDir"
    for file in "/$scriptDir"/dist*
    do
        echo $file
        if [ -f $file ]; then
          bash $file
        fi
    done

    mv list.* $mirrorDir

    chmod -R 0755 $mirrorDir
    chown ${APT_CACHER_NG_USER}:${APT_CACHER_NG_USER} $mirrorDir
    cd $curDir

    echo "mirror lists created, starting server"
  fi
}

update_config(){
  if grep -q "BindAddress: 0.0.0.0" $acngConf; then
    echo "updating acng.conf"
    bash /update_conf.sh
    echo "updating finished"
  else
    echo "config already modified"
  fi
}

create_pid_dir
create_cache_dir
create_log_dir
mirror_lists
update_config

# allow arguments to be passed to apt-cacher-ng
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == apt-cacher-ng || ${1} == $(command -v apt-cacher-ng) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch apt-cacher-ng
if [[ -z ${1} ]]; then
  exec start-stop-daemon --start --chuid ${APT_CACHER_NG_USER}:${APT_CACHER_NG_USER} \
    --exec "$(command -v apt-cacher-ng)" -- -c /etc/apt-cacher-ng ${EXTRA_ARGS}
else
  exec "$@"
fi
