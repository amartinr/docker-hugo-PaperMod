#!/bin/sh
set -e

function hugo_init() {
    if [ ! -d $BASEDIR/$SITE_DIRNAME/themes ]; then
        if [ "$THEME_FORMAT" == "yaml" ]; then
            hugo new site $SITE_DIRNAME --format $THEME_FORMAT --force
        else
            hugo new site $SITE_DIRNAME --force
        fi
        cd $BASEDIR/$SITE_DIRNAME
        THEME_REPO=${THEME_URL##*/}
        THEME_NAME=${THEME_REPO##*-}
        git init
        git submodule add --depth=1 $THEME_URL themes/$THEME_NAME
        git submodule update --init --recursive
        if [ "$THEME_FORMAT" == "yaml" ]; then
            echo baseURL: $BASEURL | tee hugo.$THEME_FORMAT
            echo languageCode: $SITE_LANG | tee -a hugo.$THEME_FORMAT
            echo theme: $THEME_NAME | tee -a hugo.$THEME_FORMAT
            echo title: $SITE_TITLE | tee -a hugo.$THEME_FORMAT
        fi
    fi
    test -d $BASEDIR/prod || mkdir $BASEDIR/prod
    test -d $BASEDIR/devel || mkdir $BASEDIR/devel
}

function hugo_build() {
    exec hugo build \
        --logLevel warn -b $BASEURL \
        -e production \
        --source $BASEDIR/$SITE_DIRNAME \
        --minify \
        --cleanDestinationDir -d $BASEDIR/prod
}

if [ "$1" == "hugo" ]; then
    if [ -n "$2" ]; then
        if [ "$2" == "server" ]; then
            hugo_init
            exec "$@" -e development \
                --logLevel debug -b $DEV_BASEURL -D \
                --bind 0.0.0.0 \
                --port $DEV_PORT \
                --liveReloadPort $LIVERELOAD_PORT \
                --disableFastRender \
                --appendPort=$APPEND_DEV_PORT \
                --source $BASEDIR/$SITE_DIRNAME \
                -d $BASEDIR/devel
        elif [ "$2" == "build" ]; then
            hugo_init
            hugo_build
        else
            exec "$@"
        fi
    else
        hugo_init
        hugo_build
    fi
else
    exec "$@"
fi
