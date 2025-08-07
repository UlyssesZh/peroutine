FROM ruby:3-alpine

RUN apk add --no-cache supercronic tzdata

WORKDIR /root

COPY peroutine .
RUN mkdir -p .local/share/peroutine
VOLUME [ "/root/.local/share/peroutine" ]

COPY crontab .
# Must use full path for supercronic command: https://github.com/aptible/supercronic/issues/181
CMD [ "/usr/bin/supercronic", "crontab" ]
