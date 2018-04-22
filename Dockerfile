# =========================================================================
# =========================================================================
#
#	Dockerfile
#	  Dockerfile for debian-base (docker utilities base) 
#		in a Debian 9.4 docker container.
#
# =========================================================================
#
# @author Jay Wheeler.
# @version 3.0.4
# @copyright © 2017, 2018. EarthWalk Software.
# @license Licensed under the Academic Free License version 3.0
# @package debian-base
# @subpackage Dockerfile
#
# =========================================================================
#
#	Copyright © 2017, 2018. EarthWalk Software
#	Licensed under the Academic Free License, version 3.0.
#
#	Refer to the file named License.txt provided with the source,
#	or from
#
#		http://opensource.org/licenses/academic.php
#
# =========================================================================
# =========================================================================
#
#    Modified nimmis/ubuntu
#       earthwalksoftware/ubuntu-base - to support 17.04 and 17.10,
#       earthwalksoftware/debian-base - to Debian 9.x.
#
# =========================================================================
# =========================================================================
FROM debian:9.4

MAINTAINER Jay Wheeler <EarthWalkSoftware@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg-divert --local --rename --add /sbin/initctl \
 && ln -sf /bin/true /sbin/initctl \
 && echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && sed -i 's/^#\s*\(deb.*multiverse\)$/\1/g' /etc/apt/sources.list \
 && apt-get -y update \
 && apt-get -y upgrade \ 
 && apt-get -y install \
       apt \
       apt-transport-https \
       cron \
       curl \
       git \
       gnupg2 \
       less \
       libcurl3-gnutls \
       locales \
       logrotate \
       lsb-release \
       nano \
       patch \
       procps \
       psmisc \
       software-properties-common \
       sudo \
       supervisor \
       syslog-ng \
       syslog-ng-core \
       unzip \
       wget \
       zip \
 && apt-get -y dist-upgrade \
 && apt-get clean all \
 && locale-gen en_US \
 && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
 && mkdir -p /etc/workaround-docker-2267/ \
 && mkdir -p /etc/container_environment \
 && mkdir -p /etc/my_runonce \
 && mkdir -p /etc/my_runalways \
 && sed -i -E 's/^(\s*)system\(\);/\1unix-stream("\/dev\/log");/' /etc/syslog-ng/syslog-ng.conf 

COPY scripts/. /

ENV HOME /root
WORKDIR /root

ENTRYPOINT ["/my_init", "--quiet"]
CMD ["/bin/bash"]
