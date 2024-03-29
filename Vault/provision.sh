#!/bin/bash
# remove comment if you want to enable debugging
#set -x
variables ()
{
if [ ! -f /vagrant_data/.env/.env ]; then
mkdir -p /vagrant_data/.env
cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
. /vagrant_data/.env/.env
}

vault_provision ()
{
sudo apt-get update
sudo apt-get install -y gnupg2 curl software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get update && sudo apt-get install -y vault
sudo systemctl stop vault
cat <<EOF > /etc/vault.d/vault.hcl
    storage "raft" {
    path    = "/opt/vault/data"
    node_id = "raft_node_1"
    }

    listener "tcp" {
    address     = "0.0.0.0:8200"
    tls_disable = 1
    }

    api_addr = "http://127.0.0.1:8200"
    cluster_addr = "https://127.0.0.1:8201"
    ui = true
EOF
sudo systemctl enable vault
sudo systemctl start vault
sudo systemctl status vault
}
configure_vault ()
{
    export VAULT_ADDR=${VAULT_ADDR}
    vault operator init -key-shares=${VAULT_KEY_SHARES} -key-threshold=${VAULT_KEY_THRESHOLD} > ${VAULT_INIT_FILE}
    export VAULT_UNSEAL_KEY=$(cat ${VAULT_INIT_FILE} | grep "Unseal Key 1" | awk '{print $NF}')
    export VAULT_TOKEN=$(cat ${VAULT_INIT_FILE} | grep "Initial Root Token" | awk '{print $NF}')
    echo "VAULT_UNSEAL_KEY=${VAULT_UNSEAL_KEY}" > ${VAULT_SECRET_FILE}
    echo "VAULT_TOKEN=${VAULT_TOKEN}" >> ${VAULT_SECRET_FILE}
}

start_vault ()
{   sleep 1
    echo "Unsealing Vault with the Vault address ${VAULT_ADDR}"
    vault operator unseal ${VAULT_UNSEAL_KEY}
    vault login ${VAULT_TOKEN}
    vault auth enable ${APPROLE_AUTH_PATH}
    vault secrets enable -path=${VAULT_PATH} -version=2 kv
}

create_policy ()
{
  tee ${VAULT_POLICY_FILE} <<EOF
  path "${VAULT_PATH}/*" {
    capabilities = ["read", "list"]
  }
EOF
  vault policy write ${APPROLE_POLICY_NAME} ${VAULT_POLICY_FILE}
}

create_approle ()
{
  vault write auth/${APPROLE_AUTH_PATH}/role/${APPROLE_ROLE_NAME} token_num_uses=${TOKEN_NUM_USES} secret_id_num_uses=${SECRET_ID_NUM_USES} policies=${APPROLE_POLICY_NAME}
  vault write -f auth/${APPROLE_AUTH_PATH}/role/${APPROLE_ROLE_NAME}/secret-id > ${VAULT_SECRET_ID_FILE}
  vault read auth/${APPROLE_AUTH_PATH}/role/${APPROLE_ROLE_NAME}/role-id > ${VAULT_ROLE_ID_FILE}
}

create_app_secrets ()
{
  vault kv put ${VAULT_PATH}/${VAULT_SECRET_NAME} username=${VAULT_SECRET_KEY} password=${VAULT_SECRET_VALUE} > ${APP_SECRET_FILE}
}

variables
vault_provision
configure_vault
start_vault
create_policy
create_approle
create_app_secrets