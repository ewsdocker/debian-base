# =========================================================================
# =========================================================================
#
#	runTemplate
#	  Run script for command-line containers from template
#
# =========================================================================
#
# @author Jay Wheeler.
# @version 0.0.1
# @copyright © 2019. EarthWalk Software.
# @license Licensed under the GNU General Public License, GPL-3.0-or-later.
# @package ewsdocker/lms-utilities
# @subpackage runTemplate
#
# =========================================================================
#
#	Copyright © 2019. EarthWalk Software
#	Licensed under the GNU General Public License, GPL-3.0-or-later.
#
#   This file is part of ewsdocker/lms-utilities.
#
#   ewsdocker/lms-utilities is free software: you can redistribute 
#   it and/or modify it under the terms of the GNU General Public License 
#   as published by the Free Software Foundation, either version 3 of the 
#   License, or (at your option) any later version.
#
#   ewsdocker/lms-utilities is distributed in the hope that it will 
#   be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
#   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with ewsdocker/lms-utilities.  If not, see 
#   <http://www.gnu.org/licenses/>.
#
# =========================================================================
# =========================================================================

read -d '' runEntry << TEMPLATE
#!/bin/bash
docker run --rm \
-it \
-v /etc/localtime:/etc/localtime:ro \
-e LMS_HOME=\${HOME} \
-e LMS_BASE=\${HOME}/.local \
-e LMS_CONF=\${HOME}/.config \
-v "\${HOME}"/.config/docker/${LMSBUILD_NAME}-${LMSBUILD_VERSION}${LMSBUILD_VERS_EXT}:\${HOME} \
-v "\${HOME}"/.config/docker/${LMSBUILD_NAME}-${LMSBUILD_VERSION}${LMSBUILD_VERS_EXT}/workspace:/workspace \
--name=${LMSBUILD_NAME}-${LMSBUILD_VERSION}${LMSBUILD_VERS_EXT} \
${LMSBUILD_REPO}/${LMSBUILD_FULLNAME}
TEMPLATE

