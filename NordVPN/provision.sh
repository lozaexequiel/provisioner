#!/bin/bash

header ()
{
echo "#################################################"
echo "#                                               #"
echo "#             NORDVPN PROVISIONER               #"
echo "#                                               #"
echo "#################################################"
echo ""
}

variables ()
{
if [ ! -f /vagrant_data/.env/.env ]; then
mkdir -p /vagrant_data/.env/
cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
ls -la /vagrant_data/.env/
. /vagrant_data/.env/.env
}

install_NordVPN ()
{
echo "Installing NordVPN"
apt update
sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)
if [ -z "${NORDVPN_TOKEN}" ]; then
    echo "NORDVPN_TOKEN is not set. Please set it and rerun the script."
    exit 1
fi
nordvpn login --token ${NORDVPN_TOKEN}
}

configure_NordVPN_client ()
{
echo "Configuring NordVPN client..."
if [ -z "${NORDVPN_TECHNOLOGY}" ]; then
NORDVPN_TECHNOLOGY=openvpn
echo "The variable 'NORDVPN_TECHNOLOGY' is not set..."
echo "Setting default value: ${NORDVPN_TECHNOLOGY}"
echo "[TIP] Available options are: OPENVPN and NORDLYNX. Please choose one and set in the variable NORDVPN_TECHNOLOGY in the .env file."
fi
nordvpn set technology ${NORDVPN_TECHNOLOGY}
if [ -z "${NORDVPN_MESHNET}" ]; then
echo "NORDVPN_MESHNET is not set. Please set it and rerun the script."
exit 1
fi
nordvpn set meshnet ${NORDVPN_MESHNET}
}

connect_NordVPN_server ()
{
echo "Configuring NordVPN server, checking if variables NORDVPN_SERVER or NORDVPN_DEDICATED_IP are set"
if [ -n "${NORDVPN_SERVER}" ]; then
    echo "Connecting to NordVPN server: ${NORDVPN_SERVER}"
    nordvpn connect ${NORDVPN_SERVER}
elif [ -n "${NORDVPN_DEDICATED_IP}" ]; then
    echo "Connecting to NordVPN dedicated IP: ${NORDVPN_DEDICATED_IP}"
    nordvpn set autoconnect enabled ${NORDVPN_DEDICATED_IP}
else
    echo "Neither NORDVPN_SERVER nor NORDVPN_DEDICATED_IP is set. Please set one of them and rerun the script."
    exit 1
fi
}

permission_meshnet ()
{
echo "Allowing routing traffic through meshnet"
devices=("${NORDVPN_MOBILE_DEVICE}" "${NORDVPN_DESKTOP_DEVICE}")
for device in "${devices[@]}"; do
    if [ -n "${device}" ]; then
        nordvpn meshnet peer routing allow ${device}
    fi
done
}

permission_local_network ()
{
echo "Allowing traffic through local network"
devices=("${NORDVPN_MOBILE_DEVICE}" "${NORDVPN_DESKTOP_DEVICE}")
for device in "${devices[@]}"; do
    if [ -n "${device}" ]; then
    nordvpn meshnet peer local allow ${device}        
    fi
done
}

remote_access_permissions ()
{
echo "Allowing remote access permissions"
devices=("${NORDVPN_MOBILE_DEVICE}" "${NORDVPN_DESKTOP_DEVICE}")
for device in "${devices[@]}"; do
    if [ -n "${device}" ]; then
    nordvpn meshnet peer incoming allow ${device}
    fi
done
}

header
variables
install_NordVPN
configure_NordVPN_client
permission_meshnet
permission_local_network
remote_access_permissions
connect_NordVPN_server