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
# @version 9.6.3
# @copyright © 2017-2019. EarthWalk Software.
# @license Licensed under the GNU General Public License, GPL-3.0-or-later.
# @package ewsdocker/debian-base
# @subpackage Dockerfile
#
# =========================================================================
#
#	Copyright © 2017-2019. EarthWalk Software
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

ARG ARGBUILD_NAME="debian-base"
ARG ARGBUILD_VERSION="9.6.3"
ARG ARGBUILD_EXT=

ARG ARG_LIBRARY="0.1.2"
#ARG ARG_SOURCE=http://alpine-nginx-pkgcache

# ==============================================================================

ARG ARG_FROM_REPO="debian"
ARG ARG_FROM_VERS="9.6"
ARG ARG_FROM_EXT=

FROM ${ARG_FROM_REPO}:${ARG_FROM_VERS}

# ==============================================================================

MAINTAINER Jay Wheeler <ewsdocker@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# ==============================================================================
# ==============================================================================
#
# https://github.com/ewsdocker/lms-utilities/releases/download/lms-utilities-0.1.2/lms-library-0.1.2.tar.gz
#
# ==============================================================================
# ==============================================================================

# =========================================================================
#
#   ARG_SOURCE <== url of the local source (http://alpine-nginx-pkgcache), 
#                   otherwise external source.
#
#       Build option:
#         --build-arg ARG_SOURCE=http://alpine-nginx-pkgcache --network=pkgnet
#
# =========================================================================

ARG ARGBUILD_VERSION

ARG ARGBUILD_NAME 
ARG ARGBUILD_REPO
ARG ARGBUILD_REGISTRY

ARG ARG_FROM_REPO
ARG ARG_FROM_VERS
ARG ARG_FROM_EXT

ARG ARG_LIBRARY
ARG ARG_SOURCE

# =========================================================================

ENV PKG_VERS="${ARG_LIBRARY}"

ENV PKG_HOST=${ARG_SOURCE:-"https://github.com/ewsdocker/lms-utilities/releases/download/lms-library-${PKG_VERS}"} 
ENV PKG_NAME="lms-library-${PKG_VERS}.tar.gz" 
ENV PKG_DIR="usr" 
ENV PKG_URL="${PKG_HOST}/${PKG_NAME}"

# =========================================================================
#
# Additional settings
#
# =========================================================================

ENV LMSOPT_QUIET=1 

ENV LMS_BASE="/usr/local" 

ENV LMSBUILD_REPO=ewsdocker

ENV LMSBUILD_REGISTRY=""
ENV LMSBUILD_NAME=debian-base
ENV LMSBUILD_VERSION="${ARGBUILD_VERSION}"

ENV LMSBUILD_DOCKER="${LMSBUILD_REPO}/${LMSBUILD_NAME}:${LMSBUILD_VERSION}"
ENV LMSBUILD_PACKAGE="${ARG_FROM_REPO}:${ARG_FROM_VERS}"

# =========================================================================
#
#   install required scripts
#
# =========================================================================

COPY scripts/. /

# =========================================================================
#
#   install packages and applications
#
# =========================================================================

RUN \
 #
 #
 #
 dpkg-divert --local --rename --add /sbin/initctl \
 #
 #  setup apt
 #
 && ln -sf /bin/true /sbin/initctl \
 && echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && sed -i 's/^#\s*\(deb.*multiverse\)$/\1/g' /etc/apt/sources.list \
 #
 #  update the apt cache, install package upgrades and install required software
 #
 && apt-get -y update \
 && apt-get -y upgrade \
 && apt-get -y install \
       apt-transport-https \
       bash-completion \
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
 #
 #   generate locale for en_US
 #
 && locale-gen en_US \
 && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
 #
 #   fixes for ubuntu/debian
 #
 && mkdir -p /etc/workaround-docker-2267/ \
 && mkdir -p /etc/container_environment \
 && mkdir -p /etc/my_runonce \
 && mkdir -p /etc/my_runalways \
 && sed -i -E 's/^(\s*)system\(\);/\1unix-stream("\/dev\/log");/' /etc/syslog-ng/syslog-ng.conf \
 #
 #   download and install lms-library
 #
 && cd / \
 && wget "${PKG_URL}" \
 && tar -xvf "${PKG_NAME}" \
 && rm "${PKG_NAME}" \
 #
 #   register the installed software
 #
 && echo "Debian v. $(cat /etc/debian_version)" >  /etc/ewsdocker-builds.txt \
 && printf "${LMSBUILD_DOCKER} (${LMSBUILD_PACKAGE}), %s @ %s\n" `date '+%Y-%m-%d'` `date '+%H:%M:%S'` >> /etc/ewsdocker-builds.txt  
 
# =========================================================================
#
#   setup libraries and applications to run
#
# =========================================================================

RUN chmod 775 /usr/local/bin/*.* \
 && chmod 775 /usr/bin/lms/*.* \
 && ln -s /usr/bin/lms/lms-setup.sh /usr/bin/lms-setup \
 && ln -s /usr/bin/lms/lms-version.sh /usr/bin/lms-version

# =========================================================================

VOLUME /conf
VOLUME /usrlocal

WORKDIR /root

# =========================================================================

ENTRYPOINT ["/my_init", "--quiet"]
CMD ["/bin/bash"]
