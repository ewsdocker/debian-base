# =========================================================================
# =========================================================================
#
#	Dockerfile
#	  Dockerfile for debian-base (docker utilities base) 
#		in a Debian container.
#
# =========================================================================
#
# @author Jay Wheeler.
# @version 3.0.9
# @copyright © 2017, 2018. EarthWalk Software.
# @license Licensed under the GNU General Public License, GPL-3.0-or-later.
# @package ewsdocker/debian-base
# @subpackage Dockerfile
#
# =========================================================================
#
#	Copyright © 2017, 2018. EarthWalk Software
#	Licensed under the GNU General Public License, GPL-3.0-or-later.
#
#   This file is part of ewsdocker/debian-base.
#
#   ewsdocker/debian-base is free software: you can redistribute 
#   it and/or modify it under the terms of the GNU General Public License 
#   as published by the Free Software Foundation, either version 3 of the 
#   License, or (at your option) any later version.
#
#   ewsdocker/debian-base is distributed in the hope that it will 
#   be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
#   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with ewsdocker/debian-base.  If not, see 
#   <http://www.gnu.org/licenses/>.
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

# =========================================================================
#
# set the LMS directories on the docker host
#
# =========================================================================

ENV LMS_BASE="/usr/local"

# =========================================================================

ENV LMSBUILD_VERSION="3.0.9"
ENV LMSBUILD_NAME=debian-base 
ENV LMSBUILD_DOCKER="ewsdocker/${LMSBUILD_NAME}:${LMSBUILD_VERSION}" 
ENV LMSBUILD_PACKAGE="debian-9.4"

# =========================================================================

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
 && locale-gen en_US \
 && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
 && mkdir -p /etc/workaround-docker-2267/ \
 && mkdir -p /etc/container_environment \
 && mkdir -p /etc/my_runonce \
 && mkdir -p /etc/my_runalways \
 && sed -i -E 's/^(\s*)system\(\);/\1unix-stream("\/dev\/log");/' /etc/syslog-ng/syslog-ng.conf \
 && echo "Debian v. $(cat /etc/debian_version)" >  /etc/ewsdocker-builds.txt \
 && printf "${LMSBUILD_DOCKER} (${LMSBUILD_PACKAGE}), %s @ %s\n" `date '+%Y-%m-%d'` `date '+%H:%M:%S'` >> /etc/ewsdocker-builds.txt  

# =========================================================================

COPY scripts/. /

RUN chmod 775 /usr/local/bin/*.* \
 && chmod 775 /usr/bin/lms/setup \
 && chmod 600 /usr/local/share/applications/debian-base.desktop \
 && ln -s /usr/bin/lms/setup /usr/bin/lms-setup \
 && ln -s /usr/bin/lms/version /usr/bin/lms-version

# =========================================================================

VOLUME /conf
VOLUME /usrlocal
ENV HOME /root
WORKDIR /root

# =========================================================================

ENTRYPOINT ["/my_init", "--quiet"]
CMD ["/bin/bash"]
