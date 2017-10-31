# Makefile for KBase specific JRE image
#
# Author: Steve Chan sychan@lbl.gov
#

NAME := "kbase/kb_jre"

all: docker_image

docker_image:
	wget https://github.com/kbase/dockerize/raw/dist/dockerize-alpine-linux-amd64-v0.5.0.tar.gz
	tar xvzf dockerize-alpine-linux-amd64-v0.5.0.tar.gz
	IMAGE_NAME=$(NAME) hooks/build

push_image:
	IMAGE_NAME=$(NAME) ./push2dockerhub.sh
