FROM postgres:latest
MAINTAINER Christoph René Pardon <info@boonweb.de>

VOLUME /dump

ENTRYPOINT ["/start.sh"]
CMD [""]

ADD dump.sh /dump.sh
RUN chmod +x /dump.sh

ADD start.sh /start.sh
RUN chmod +x /start.sh

RUN apt update \
    && apt install -y cron zip \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* \
