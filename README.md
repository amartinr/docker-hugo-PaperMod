# Intro
This is a simple Dockerfile to build a container running Hugo with SaSS support on ARM64 hosts (you can easily adapt it to your needs modifying the line installing the SaSS binaries).

By default, it will initialise a new Hugo site with PaperMod as its default theme. You can choose a different theme using the environment variable `THEME_URL`, which must point to a git repo containing a valid Hugo theme. Bear in mind that themes requiring additional steps for being installed will fail.

# Usage
## Docker
Once build, you can quickly check this container with the following command. Create a directory named `localhost` first.

```
docker run -p 127.0.0.1:1313:1313 --mount type=bind,source=$PWD/localhost,destination=/srv/hugo/localhost amartinr/hugo
```

If you want to try a different theme, clear the contents of the directory named `localhost` and use the environment variable `THEME_URL`.

```
docker run -p 127.0.0.1:1313:1313 --mount type=bind,source=$PWD/localhost,destination=/srv/hugo/localhost -e THEME_URL=https://github.com/hanwenguo/hugo-theme-nostyleplease amartinr/hugo
```

This is a simple `docker-compose.yml` that allows you to make changes from the host editing the contents of the folder `localhost` (you can choose a different name and path).

```
services:
  hugo:
    image: amartinr/hugo
    environment:
      - BASE_URL=https://my-site.tld
      - DEV_BASEURL=http://localhost
    volumes:
      - ./localhost:/srv/hugo/localhost
      - prod:/srv/hugo/prod
volumes:
  prod:
```

Once you're happy with the results you can run `docker-compose run --rm <container_name> hugo build` to generate the static files for your production environment in a volume named `prod`.

## Environment variables
The following env variables can be used to suit your needs. Their defaults are shown as well.

```
THEME_URL="${THEME_URL:-https://github.com/adityatelange/hugo-PaperMod.git}"
THEME_FORMAT="${THEME_FORMAT:-yaml}"
SITE_DIRNAME="${SITE_DIRNAME:-localhost}"
SITE_TITLE="${SITE_TITLE:-My personal blog}"
SITE_LANG="${SITE_LANG:-en-us}"
BASEURL="${BASEURL:-http://localhost}"
DEV_PORT="${DEV_PORT:-1313}"
APPEND_DEV_PORT="${APPEND_DEV_PORT:-true}"
DEV_BASEURL="${DEV_BASEURL:-http://localhost}"
LIVERELOAD_PORT="${DEV_PORT}"
```
