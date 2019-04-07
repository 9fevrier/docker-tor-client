FROM alpine:3.9
MAINTAINER SAS 9 Février <contact@9fevrier.com>

ENV EXIT_NODES ""
ENV COUNTRY ""
ENV PASSWORD "TheF@m0usP@ssw0rd"
ENV TORRC_PATH "/home/tor/torrc"

EXPOSE 9150 9051

COPY ["./adds/", "/"]

RUN apk --no-cache add tor \
 && chmod a+w /tmp/torrc

USER tor

ENTRYPOINT ["/opt/entry-point.sh"]
CMD []
