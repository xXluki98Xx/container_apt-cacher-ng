#!/bin/bash
set -e

curDir=$PWD

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

update_config(){
  sed "s#CacheDir: /var/cache/apt-cacher-ng#CacheDir: ${APT_CACHER_NG_CACHE_DIR}#" -i /etc/apt-cacher-ng/acng.conf
  sed "s#LogDir: /var/log/apt-cacher-ng#LogDir: ${APT_CACHER_NG_LOG_DIR}#" -i /etc/apt-cacher-ng/acng.conf
}

mirror_lists(){
  scriptDir='mirror_scripts'
  mirrorDir='/etc/apt-cacher-ng/mirror_list.d/'

  if [ -z "$(ls -A /etc/apt-cacher-ng/mirror_list.d)" ]; then
    echo "mirror lists doesnt exist, will created"

    cd "/$scriptDir"
    for file in "/$scriptDir/dist-*.sh"
    do
        echo $file
        if [ -f $file ];then
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

set_config(){
  cp -u /acng.conf /etc/apt-cacher-ng/acng.conf  
}

set_config
create_pid_dir
create_cache_dir
create_log_dir
update_config
mirror_lists

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
