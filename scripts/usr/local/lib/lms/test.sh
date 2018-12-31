source ./lmsNetwork-0.0.1.bash

lmsNet_Name="internet.lan"
lmsNet_hostname="subversion"

echo
echo "###########################################################"
echo

lmsNetIP
[[ $? -eq 0 ]] ||
 {
    echo "lmsNetIP failed: $? <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    exit 1
 }

echo
echo "___________________________________________________________"
echo

lmsNetCreate $lmsNet_ipGateway $lmsNet_info $lmsNet_Name 
[[ $? -eq 0 ]] ||
 {
    echo "lmsNetCreate failed: $? <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    exit 1
 }

echo
echo "___________________________________________________________"
echo

lmsNetGenNewMAC ${lmsNet_hostname}
[[ $? -eq 0 ]] ||
 {
    echo "lmsNetGenNewMAC failed: $? <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    exit 2
 }

echo
echo "___________________________________________________________"
echo

lmsNetGetFreeIp $lmsNet_MAC $lmsNet_Name $lmsNet_hostname
[[ $? -eq 0 ]] ||
 {
    echo "lmsNetGetFreeIp failed: $? <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    exit 3
 }

echo
echo "============================================================"
echo

echo "lmsNet_containerIP = $lmsNet_containerIP"

exit 0