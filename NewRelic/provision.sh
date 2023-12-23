#!/bin/bash
#set -x
header ()
{
echo "#################################################"
echo "#                                               #"
echo "#             NEW RELIC PROVISIONER             #"
echo "#                                               #"
echo "#################################################"
}
variables ()
{
if [ ! -f /vagrant_data/.env/.env ]; then
cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
ls -la /vagrant_data/.env/
. /vagrant_data/.env/.env
}

install_new_relic ()
{
curl -Ls ${NEW_RELIC_URL} | bash && sudo NEW_RELIC_API_KEY=${NEW_RELIC_API_KEY} NEW_RELIC_ACCOUNT_ID=${NEW_RELIC_ACCOUNT_ID} ${NEW_RELIC_PATH} install -y --tag ${NEW_RELIC_TAG}
}
header
variables
install_new_relic