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
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community hugo
RUN wget https://github.com/sass/dart-sass/releases/download/1.85.1/dart-sass-1.85.1-linux-arm64-musl.tar.gz -O - | tar  -C /usr/local/bin --strip-components=1 -zx -f -
COPY ./entrypoint.sh /entrypoint.sh

ENV THEME_URL="${THEME_URL:-https://github.com/adityatelange/hugo-PaperMod.git}"
ENV THEME_FORMAT="${THEME_FORMAT:-yaml}"
ENV SITE_DIRNAME="${SITE_DIRNAME:-localhost}"
ENV SITE_TITLE="${SITE_TITLE:-My personal blog}"
ENV SITE_LANG="${SITE_LANG:-en-us}"
ENV BASEURL="${BASEURL:-http://localhost}"
ENV DEV_PORT="${DEV_PORT:-1313}"
ENV APPEND_DEV_PORT="${APPEND_DEV_PORT:-true}"
ENV DEV_BASEURL="${DEV_BASEURL:-http://localhost}"
ENV LIVERELOAD_PORT="${DEV_PORT}"

USER hugo
WORKDIR $BASEDIR
ENTRYPOINT ["/entrypoint.sh"]
CMD ["hugo", "server"]
