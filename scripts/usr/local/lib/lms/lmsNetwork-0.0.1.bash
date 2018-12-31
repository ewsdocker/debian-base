#!/bin/bash
# =========================================================================
# =========================================================================
#
#	lmsNetworkUtils
#     network query libraries - requirements resolved in debian-base
#
# =========================================================================
#
# @author Jay Wheeler.
# @version 0.0.1
# @copyright © 2018. EarthWalk Software.
# @license Licensed under the GNU General Public License, GPL-3.0-or-later.
# @package ewsdocker/debian-base
# @subpackage lmsNetworkUtils
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

lmsNet_containerIP=

lmsNet_info=

lmsNet_ipAddress=
lmsNet_ipGateway=
lmsNet_ipInterface=

lmsNet_MAC=
lmsNet_Name=

lmsNet_routeInfo=

# =========================================================================
#
#   lmsNetIP
#		get the network ip address and related info
#
#	parameters:
#		none
#	returns:
#		0 = no errors
#		non-zero = error code
#
# =========================================================================
function lmsNetIP()
{
	lmsNet_routeInfo=$(ip route | grep default )
	 [[ $? -eq 0 ]] || return 1

	lmsNet_ipGateway=$(echo ${lmsNet_routeInfo} | awk '{ print $3}')
	 [[ $? -eq 0 ]] || return 2

	lmsNet_ipInterface=$(echo ${lmsNet_routeInfo} | awk '{ print $5}')
	 [[ $? -eq 0 ]] || return 3

	lmsNet_ipAddress=$(ip addr | grep -A1 ${lmsNet_ipInterface} | grep "inet " | awk '{print $2}' | awk -F "/" '{print $1}')
	 [[ $? -eq 0 ]] || return 4

	lmsNet_info=$(ip route | grep -m1 ${lmsNet_ipAddress} | awk '{print $1}')
	 [[ $? -eq 0 ]] || return 5

echo "lmsNetIP: routeInfo=$lmsNet_routeInfo, ipGateway=$lmsNet_ipGateway, ipInterface=$lmsNet_ipInterface, ipAddress=$lmsNet_ipAddress, info=$lmsNet_info"
    return 0
}

# =========================================================================
#
#   lmsNetCreate
#		create a 
#
#	parameters:
#		adapterMAC = adapter MAC address
#       netName = network name
#		hostname = host name 
#	returns:
#		0 = no errors
#		non-zero = error code
#
# =========================================================================
function lmsNetCreate()
{
	local lGateway="${1}"
	local lSubnet="${2}"
	local lName="${3}"
echo "lmsNetCreate: gateway=$lGateway, subnet=$lSubnet, name=$lName"

	[[ -z "${lGateway}" || -z "${lSubnet}" ||-z "${lName}" ]] && return 1

	docker network create --gateway ${lGateway} --subnet ${lSubnet} ${lName}
	[[ $? -eq 0 ]] || return 3

	return 0
}

# =========================================================================
#
#   lmsNetGenNewMAC 
#		generate MAC address from hostname
#
#	parameters:
#		hostname = (optional) host name to generate MAC from
#	returns:
#		0 = no errors
#		non-zero = error code
#
# =========================================================================
function lmsNetGenNewMAC()
{
	local lhostName="${1}"

	[[ -z "${lhostName}" ]] && return 1

	lmsNet_MAC=$( echo ${lhostName}|md5sum|sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02:\1:\2:\3:\4:\5/' )
     [[ $? -eq 0 ]] || return 2

    return 0
}

# =========================================================================
#
#   lmsNetGetFreeIp
#		get a free ip from busybox dhcp
#
#	parameters:
#		adapterMAC = adapter MAC address
#       netName = network name
#		hostname = host name 
#	returns:
#		0 = no errors
#		non-zero = error code
#
# =========================================================================
function lmsNetGetFreeIp()
{
	local lMAC="${1}"
	local lNetName="${2}"
	local lHostname="${3}"

echo "lmsNetGetFreeIp: lMAC=$lMAC, lNetName=$lNetName, lHostname=$lHostname"

	commandString="docker run --name=lmsnetwork --net ${lNetName} --rm --cap-add NET_ADMIN --mac-address ${lMAC} busybox udhcpc -x hostname:${lHostname} 2>&1 | grep lease | awk '{print $4}'"
echo "lmsNetGetFreeIp: $commandString"

echo
echo $( $commandString )
echo

#result=$( docker run --name=lmsnetwork --net ${lNetName} --rm --cap-add NET_ADMIN --mac-address ${lMAC} busybox udhcpc -x hostname:${lHostname} )
#echo $result

#docker run --name=lmsnetwork --net ${lNetName} --rm --cap-add NET_ADMIN --mac-address ${lMAC} busybox udhcpc -x \"hostname:${lHostname}\" 2>&1 | grep lease | awk '{print $4}'
#	lmsNet_containerIP=$(docker run --name=lmsnetwork --net ${lNetName} --rm --cap-add NET_ADMIN --mac-address ${lMAC} busybox udhcpc -x \"hostname:${lHostname}\" 2>&1 | grep lease | awk '{print $4}')
	return $?
}

