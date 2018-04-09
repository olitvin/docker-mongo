FROM mongo:3.4.9
MAINTAINER Positron <positron@jarm.com>

ENV MONGO_PORT "27017"
ENV MONGO_DB "test"
ENV MONGO_USER "username"
ENV MONGO_PASS "password"

COPY mongo_run.sh /mongo_run.sh
RUN chmod a+x /mongo_run.sh

VOLUME ["/data/db", "/data/backup"]

EXPOSE $MONGO_PORT

ENTRYPOINT [""]
CMD ["/mongo_run.sh"]
