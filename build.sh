#!/bin/sh
set -xe
init_src() {
    local piplin_ver=1.0
    [ -f ${piplin_ver}.tar.gz ] || curl -o ${piplin_ver}.tar.gz -fSL "https://github.com/Piplin/Piplin/archive/${piplin_ver}.tar.gz"

    if [ ! -d src ]; then 
        mkdir src
    else
        local srcdir=$(date +%Y%m%d%H%M)
        echo "src directory already exists, renamed as src_$srcdir."
        mv src src_${srcdir}
        mkdir src
    fi
    tar xzf ${piplin_ver}.tar.gz --strip-components=1 -C src/
    cp .env.docker src/.env
}

init_src
docker-compose -p piplin build
