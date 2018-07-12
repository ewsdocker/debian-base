# =========================================================================================
# =========================================================================================
#
#	lmsErrorExit
#	  Output a message, error code and exit the script.
#
# =========================================================================================
#
# @author Jay Wheeler.
# @version 0.0.2
# @copyright © 2017, 2018. EarthWalk Software.
# @license Licensed under the GNU General Public License, GPL-3.0-or-later.
# @package ewsdocker/debian-kaptain-menu
# @subpackage lmsErrorExit
#
# =========================================================================
#
#	Copyright © 2017, 2018. EarthWalk Software
#	Licensed under the GNU General Public License, GPL-3.0-or-later.
#
#   This file is part of ewsdocker/debian-kaptain-menu.
#
#   ewsdocker/debian-kaptain-menu is free software: you can redistribute 
#   it and/or modify it under the terms of the GNU General Public License 
#   as published by the Free Software Foundation, either version 3 of the 
#   License, or (at your option) any later version.
#
#   ewsdocker/debian-kaptain-menu is distributed in the hope that it will 
#   be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
#   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with ewsdocker/debian-kaptain-menu.  If not, see 
#   <http://www.gnu.org/licenses/>.
#
#
# =========================================================================================
# =========================================================================================

# =========================================================================================
#
#    errorExit - Output error message and EXIT with error code
#
#    Parameters:
#		message = string to output
#       errorCode = error code to exit on
#    Result:
#        none
#
# =========================================================================================
function errorExit()
{
    local errorCode=${1:-"$XERR_UNKNOWN"}
    [[ "${errorCode}" -eq "${XERR_UNKNOWN}" ]] || (( errorCode++ ))

    lmsconDisplay "${XERR_MSG[$errorCode]}"
    exit ${errorCode}
}

