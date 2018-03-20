FROM jetty:jre8

# These ARGs values are passed in via the docker build command
ARG BUILD_DATE
ARG VCS_REF
ARG BRANCH=develop

# This is the JETTY_HOME for the jetty9 package

USER root

RUN mkdir -p /var/lib/apt/lists/partial && \
	apt-get update -y && \
    apt-get install -y ca-certificates tomcat8-user libservlet3.1-java && \
    update-ca-certificates && \
    useradd -c "KBase user" -rd /kb/deployment/ -s /bin/bash kbase && \
    mkdir -p /kb/deployment/bin && \
    chown -R kbase /kb/deployment

COPY dockerize /kb/deployment/bin

# The BUILD_DATE value seem to bust the docker cache when the timestamp changes, move to
# the end
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/kbase/kb_jre.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc1" \
      us.kbase.vcs-branch=$BRANCH \
      maintainer="Steve Chan sychan@lbl.gov"