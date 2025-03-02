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
        git init
        git submodule add --depth=1 $THEME_URL themes/$THEME_NAME
        git submodule update --init --recursive
        if [ "$THEME_FORMAT" == "yaml" ]; then
            echo baseURL: $BASEURL | tee hugo.$THEME_FORMAT
            if [ -n "$SITE_LANG" ]; then
                echo languageCode: $SITE_LANG | tee -a hugo.$THEME_FORMAT
            else
                echo languageCode: en-us | tee -a hugo.$THEME_FORMAT
            fi
            echo theme: $THEME_NAME | tee -a hugo.$THEME_FORMAT
            echo title: $SITE_TITLE | tee -a hugo.$THEME_FORMAT
        fi
    fi
    test -d $BASEDIR/devel || mkdir $BASEDIR/devel
    test -d $BASEDIR/prod || mkdir $BASEDIR/prod
}

if [ "$1" == "hugo" ]; then
    if [ -n "$2" ]; then
       if [ "$2" == "server" ]; then
            hugo_init
            "$@" --logLevel debug -b $DEV_BASEURL -d $BASEDIR/devel -D --bind 0.0.0.0 --port $DEV_PORT --liveReloadPort $LIVERELOAD_PORT --disableFastRender --appendPort=false --source $BASEDIR/$SITE_DIRNAME &
            exec "$@" --logLevel warn -b $BASEURL -e production --bind 0.0.0.0 --appendPort=false --disableLiveReload --source $BASEDIR/$SITE_DIRNAME --cleanDestinationDir -d $BASEDIR/prod
        else
            exec "$@"
        fi
    else
        hugo_init
        test -d $BASEDIR/devel || mkdir -p $BASEDIR/devel
        echo "Building development site at $DEV_BASEURL..."
        "$@" -b $DEV_BASEURL -d $BASEDIR/devel --disableFastRender ---source $BASEDIR/$SITE_DIRNAME &
        test -d $BASEDIR/prod || mkdir -p $BASEDIR/prod
        echo "Building production site at $BASEURL..."
        exec "$@" -b $BASEURL -e production --disableLiveReload --source $BASEDIR/$SITE_DIRNAME --cleanDestinationDir -d $BASEDIR/prod
    fi
else
    exec "$@"
fi
