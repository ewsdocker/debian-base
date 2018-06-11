#!/bin/bash
#=========================================================================
# =========================================================================
#
#	lmssetupContainer
#	  Copy run scripts to /userbin.
#
# =========================================================================
#
# @author Jay Wheeler.
# @version 0.0.1
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
#   rmDestFile
#
#		Remove destination file copy, if it exists
#
#	parameters:
#		fname = name of the file
#
#   returns:
#		0 = no error
#
# =========================================================================
function rmDestFile 
{
    [[ -f "${1}" ]] && rm "${1}"

    return 0
}

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

	for fname in debian-*
	do
    	[[ -f "${fname}" ]] && rmDestFile "/usrlocal/bin/${fname}"
    	cp "${fname}" "/usrlocal/bin/${fname}"
	done

	chmod +x /usrlocal/bin/*

	echo "LMS_BASE=${LMS_BASE}" > /root/lms-base.conf
	chmod 755 /root/lms-base.conf

    return 0
}

