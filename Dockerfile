FROM openjdk:8-jre
MAINTAINER Steve Chan sychan@lbl.gov

# These ARGs values are passed in via the docker build command
ARG BUILD_DATE
ARG VCS_REF
ARG BRANCH=develop

# This is the JETTY_HOME for the jetty9 package
ENV JETTY_HOME /usr/share/jetty9

# Shinto-cli is a jinja2 template cmd line tool
RUN apt-get update -y && \
    apt-get install -y ca-certificates python-minimal python-pip jetty9 wget && \
    update-ca-certificates && \
    pip install shinto-cli[yaml]

# The BUILD_DATE value seem to bust the docker cache when the timestamp changes, move to
# the end
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/kbase/kb_jre.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc1" \
      us.kbase.vcs-branch=$BRANCH
