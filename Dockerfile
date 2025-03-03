FROM alpine

ARG UID="${UID:-1000}"
ARG GID="${GID:-1000}"

ENV BASEDIR=/srv/hugo
RUN adduser \
        -u $UID \
        -G nogroup \
        -D \
        -h $BASEDIR \
        -H \
        -S \
        hugo;

RUN apk add --no-cache git
RUN apk add --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community hugo && rm -rf /var/cache/apk/*
COPY ./entrypoint.sh /entrypoint.sh

ENV THEME_URL="${THEME_URL:-https://github.com/adityatelange/hugo-PaperMod.git}"
ENV THEME_NAME="${THEME_NAME:-PaperMod}"
ENV THEME_FORMAT="${THEME_FORMAT:-yaml}"
ENV SITE_DIRNAME="${SITE_DIRNAME:-localhost}"
ENV SITE_TITLE="${SITE_TITLE:-My personal blog}"
ENV SITE_LANG="${SITE_LANG:-en-us}"
ENV BASEDIR="${BASEDIR:-/srv/hugo}"
ENV BASEURL="${BASEURL:-http://localhost}"
ENV DEV_PORT="${DEV_PORT:-1313}"
ENV APPEND_DEV_PORT="${APPEND_DEV_PORT:-true}"
ENV DEV_BASEURL="${DEV_BASEURL:-http://localhost}"
ENV LIVERELOAD_PORT="${DEV_PORT}"

USER hugo
WORKDIR $BASEDIR
ENTRYPOINT ["/entrypoint.sh"]
CMD ["hugo", "server"]
