Description
===========
Configures 

Requirements
============
Tested on CentOS 6.x

Attributes
==========
default[:locksmith][:users] - An array of users.

Usage
=====
To configure keys and passwords:

#### Generate a MD5 Password Shadow Hash
    openssl passwd -1

#### Create a databag
Create the data bag and give it keys and a password
    knife data bag create locksmith sysadmin

    {
      "id": "sysadmin",
      "keys": [
        "ssh-rsa xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx== me@mycoolcomputer.local",
        "ssh-rsa xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx== me@myothercoolcomputer.local"
      ],
      "password": "$1$my_hashed$password_created_above."
    }

#### Add the recipe and user to your node or role
    "default_attributes": {
      "locksmith": {
        "users": ["sysadmin"]
      }
    }

    recipe[locksmith]

