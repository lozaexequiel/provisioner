# Vault dev environment

To start the environment, run the following command:

```vagrant up```

This will start a virtual machine with Vault installed and configured, storing the keys and tokens in the directory ```/vagrant_data/.env```.

The vault files structure is as follows:

~~~bash
./
├── .env/
│   ├── vault/
│   │   ├── app.secret # Vault app secret information
│   │   ├── init
│   │   ├── secret
│   │   ├── role_id
│   │   ├── secret_id

~~~

## Accessing Vault

To get the initial root token to login in Vault, you can find in the following path:

```/vagrant_data/.env/vault/init```

To get the initial unseal keys to unseal Vault, you can find in the following path:

```/vagrant_data/.env/vault/secret```

## Vault documentation

The Vault full documentation can be found in [Vault website](https://www.vaultproject.io/)