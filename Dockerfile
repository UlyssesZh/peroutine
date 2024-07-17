FROM ruby:3-alpine

RUN apk add --no-cache supercronic tzdata

WORKDIR /root

COPY peroutine .
RUN mkdir -p .local/share/peroutine
VOLUME [ "/root/.local/share/peroutine" ]

COPY crontab .
CMD [ "supercronic", "crontab" ]
