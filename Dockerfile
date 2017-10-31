FROM jetty:jre8-alpine

# These ARGs values are passed in via the docker build command
ARG BUILD_DATE
ARG VCS_REF
ARG BRANCH=develop

# Jetty environment vars are inherited from base from baseimage

USER root

RUN apk update && \
    apk add ca-certificates && \
    update-ca-certificates && \
    mkdir -p /kb/deployment/bin

COPY dockerize /kb/deployment/bin

# The BUILD_DATE value seem to bust the docker cache when the timestamp changes, move to
# the end
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/kbase/kb_jre.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc1" \
      us.kbase.vcs-branch=$BRANCH \
      maintainer="Steve Chan sychan@lbl.gov"