# Terraform dev environment

If you want an specific version of Terraform you must define the next variable in the .env/.env file:

```bash
TERRAFORM_VERSION="1.4.6"
```

To start the environment, run the following command:

```vagrant up```

This will start a virtual machine with Vault installed and configured, storing the keys and tokens in the directory ```/vagrant_data/.env```.

The terraform files structure is as follows:

~~~bash
./
├── .env/
│   ├── terraform/
│   │   ├──  # Vault app secret information
│   │   ├── 
│   │   ├── secret
│   │   ├── role_id
│   │   ├── secret_id

~~~


## Terraform documentation

The terraform full documentation can be found in [Terraform website](https://www.terraform.io/docs/index.html)