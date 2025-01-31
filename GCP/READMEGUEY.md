# How to create GCP infrastructure and launch CorchroachDB using Ansible

## Table of contents

1. [Prerequisites](#prereq)
    - [Setup GCP service account](#service-Acct)
1. [Provisioning the infrastructure](#provision)
    - [Launching the GCP infrastructure](#launch)
    - [Decommissioning the GCP infrastructure](#launch)
1. [Deploying the Workshop](#workshop)
    - [Create Ansible Inventory](#inventory)
    - [SSH Setup](#ssh)
    - [Deploy Workshop Assets](#assets)
1. [Colab Notebooks](#colab)

## Prerequisites <a name="prereq"></a>

  - Have Python 3.9 or above installed
  - Ansible modules installed see [Start automating with Ansible](https://docs.ansible.com/ansible/latest/getting_started/get_started_ansible.html)
  - Have a GCP Service Account with necessary permissions
  - A GCP project create in the COCKROACHLABS account.
  - Have a public key (id_rsa.pub) created and stored in your `$USER_HOME/.ssh/id_rsa.pub` directory.
  - _**gcloud**_ configured and running to access the GCP project 

## Setup CGP service account <a name="service-acct"></a>
## Provisioning the infrastructure <a name="provision"></a>

Ansible can provision virtual machines, containers, networks, and cloud infrastructures. It can also provision cloud platforms, hypervisors, and bare-metal servers. Use the playbooks in this repository to launch, decommission the infrastructure needed for the workshop.

### Launching the GCP infrastructure  <a name="launch"></a>

Execute the ansible playbook _**dply_crdb_infra.yml**_ to launch the workshop infrastructure (i.e., compute engine, network and firewall rules, et cetera)

```
time ansible-playbook dply_crdb_infra.yml
```

roughly 3 1/2 minutes (e.g., ansible-playbook dply\_crdb\_infra.yml -vv  11.73s user 2.96s system 15% cpu 1:36.80 total

TO DO: 
- change the way the compute engine is created to number of intances instead of zones.
- create a dynamic inventory to avoid manually modifying the inventory.ini file:w

### Decommissioning the GCP infrastructure  <a name="launch"></a>

To decommision the infrastructure execute the ansibleplaybook _**decom_aws_infra.yml**_ script:

```
ansible-playbook decom_aws_infra.yml
```

## Deploying the Workshop <a name="workshop"></a>

Follow the step below to deploy the workshop assets:


### Get host IP addresses <a name="inventory"></a>

Get the external IP addresses of the compute engines and add them to the _**inventory.ini**_ file. You can use the one-liner below to **OVERWRITE** the existing _**inventory.ini**_ file.

```
% gcloud compute config-ssh --dry-run | grep HostName | sed 's/    HostName \(.*\)/\[crdbnodes\]\n\1/' > inve
ntory.ini
```

### Setup SSH <a name="ssh"></a>

- On your laptop connect to the compute engine using the public IP address:

&emsp;<code>
% ssh \<Pub Key User>@\<Compute Engine IP>
</code>

&emsp;for example:

&emsp;<p><code>
% ssh ainfanzon@35.236.16.32<br>
The authenticity of host '35.236.16.32 (35.236.16.32)' can't be established.<br>
ED25519 key fingerprint is SHA256:hi9xYVncXp8Oyz/MJzpuL4sfytyPE3ckn/6ERyZBPJA.<br>
This key is not known by any other names.<br>
Are you sure you want to continue connecting (yes/no/[fingerprint])?
</code></p>

at the prompt enter **yes**.  You should get a similar message as below:

```
Warning: Permanently added '35.236.16.32' (ED25519) to the list of known hosts.
[ainfanzon@crdb-1 ~]$
```

If all works fine you should be connected to the compute engine **[ainfanzon@crdb-1 ~]$**


- Exit from the compute engine

<code>
[ainfanzon@crdb-1 ~]$ exit<br>
logout<br>
Connection to 35.236.16.32 closed.
</code>

## Deploy Workshop Assets <a name="assets"></a>

- Execute the _**wrkshp_setup.yml**_ playbook

```
% time ansible-playbook --private-key ~/.ssh/id_rsa -i inventory.ini wrkshp_setup.yml 
```

TO DO:

- move the Flask application to another compute engine
- create another compute engine and install _**haproxy**_ and the flask application

## Colab Notebooks <a name="colab"></a>

- su to roachie





