# Setup Workshop Infastructure

## Create the Network, disk and VM

<code>% time ansible-playbook dply_crdb_infra.yml</code>

## Setup Internet/Network connectivity

- copy the public key to the VM(s)
  - VM Instance -> EDIT ->  SSH Keys -> ADD ITEM
  - Enter the public key e.g., ssh-rsa AAAAB3NzaC1yc ....
  - SAVE 

NOTE: Make sure there are no conflicts with your `known_host` file. Remove any conflicting entries

- ssh to the server<br>
 <code>ssh \<ansible user>@\<VM IP address><br>
The authenticity of host '34.94.235.236 (34.94.235.236)' can't be established.
ED25519 key fingerprint is SHA256:XrXCH1tOhD0LG18mQq5DNM7h7JH0yIoJuUip/uVXoQs.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '34.94.235.236' (ED25519) to the list of known hosts.
[ainfanzon@crdb-1 ~]$
</code>

## Deploy CRDB and the code for the workshop

- Deploy the GCP infrastructure

```time ansible-playbook dply_crdb_infra.yml```

- Copy public key to vm


- Add IP address(es) to the inventory.ini file on laptpo





- add the IPs of the VMs to the `inventory.ini` file


## Start Jupyter Lab

### Start jupyter lab on the Centos server

<code>jupyter lab --no-browser --port=8888 &</code>


### On your laptop


On the local machine, catch the forwarded port:

```
ssh -L 8888:localhost:8888 ainfanzon@\<VM ip\>
```

Note: `SSH -L` is good for exposing a remote port locally:w

