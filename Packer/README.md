# Packer dev environment

If you want an specific version of Packer you must define the next variable in the .env/.env file:

```bash
PACKER_VERSION="1.4.6"
```

To start the environment, run the following command:

```vagrant up```

This will start a virtual machine with Vault installed and configured, storing the keys and tokens in the directory ```/vagrant_data/.env```.

## Packer documentation

The Packer full documentation can be found in [Packer website](https://www.packer.io/docs/index.html)
