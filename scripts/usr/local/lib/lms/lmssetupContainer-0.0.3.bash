#!/bin/bash
# =========================================================================
# =========================================================================
#
#	lmssetupContainer
#	  Copy run scripts to /userbin.
#
# =========================================================================
#
# @author Jay Wheeler.
# @version 0.0.3
# @copyright © 2018. EarthWalk Software.
# @license Licensed under the GNU General Public License, GPL-3.0-or-later.
# @package ewsdocker/debian-base
# @subpackage lmssetupContainer
#
# =========================================================================
#
#	Copyright © 2018. EarthWalk Software
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

# =========================================================================
#
#   setupContainer
#
#		Setup required files in the proper folders
#
#	parameters:
#		none
#
#   returns:
#		0 = no error
#
# =========================================================================
function setupContainer()
{
	mkdir -p /usrlocal/share/lms
	mkdir -p /usrlocal/lib/lms
	mkdir -p /usrlocal/bin

	cp -r /usr/local/share/*      /usrlocal/share
	cp -r /usr/local/lib/lms/*    /usrlocal/lib/lms

	cd /usr/local/bin

	for fname in *
	do
	    if ! [ -d "${fname}" ]
	    then
    		if ! [ -L "${fname}" ] 
    		then
    		    if [ -f "/usrlocal/bin/${fname}" ]
    		    then
    	            rm "/usrlocal/bin/${fname}"
    	        fi
                cp "${fname}" "/usrlocal/bin"
    	    fi
        fi
	done

	lmsContainer="/conf/${LMSBUILD_NAME}-${LMSBUILD_VERSION}"
    mkdir -p "${lmsContainer}"

	echo "LMS_BASE=${LMS_BASE}" > "${lmsContainer}/lms-base.conf"
	chmod 755 "${lmsContainer}/lms-base.conf"

    return 0
}

