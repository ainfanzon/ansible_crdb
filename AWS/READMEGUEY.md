# How to create GCP infrastructure and launch CorchroachDB using Ansible
## Table of contents

1. [Prerequisites](#prereq)
1. [Provisioning the infrastructure](#provision)
    - [Launching the GCP infrastructure](#launch)
    - [Decommissioning the GCP infrastructure](#launch)
1. [Deploying the Workshop](#workshop)
    - [SSH Setup](#ssh)
    - [Deploy Workshop Assets](#assets)
1. [Execute the Workshop](#execlabs)
1. [Launch the Flask App](#execflask)
1. [References](#references)

## Prerequisites <a name="prereq"></a>

  - Have Python 3.9 or above installed
  - Ansible modules installed see [Start automating with Ansible](https://docs.ansible.com/ansible/latest/getting_started/get_started_ansible.html)
  - Have access to the AWS_Revenue account with necessary permissions
  - _**aws**_ CLI tool installed on your laptop

## Provisioning the infrastructure <a name="provision"></a>

Ansible can provision virtual machines, containers, networks, and cloud infrastructures. It can also provision cloud platforms, hypervisors, and bare-metal servers. Use the playbooks in this repository to launch, decommission the infrastructure needed for the workshop.

### Launching the GCP infrastructure  <a name="launch"></a>

Execute the ansible playbook _**dply_crdb_infra.yml**_ to launch the workshop infrastructure (i.e., ec2 instance, network and security gourp, rules, et cetera)

```
time ansible-playbook dply_crdb_infra.yml<br>
3.62s user 1.88s system 19% cpu 28.131 total
```

NOTE: By default the playbook creates one instnace. To launch more than one instance pass the number of instances at the command line using __**--extra-vars aws_inst_count=100**__ 

#### Generate the inverntory.ini file

Execute the script below to create the inventory.ini file for the ansible playbooks

```./get_pubIPs.zsh```

The script executes the following aws cli query

```
% aws ec2 describe-instances --filters "Name=tag:Name,Values=aim-*" \
                             --profile 337380398238_CRLRevenue \
                             --region us-west-2 \
                             --query 'Reservations[].Instances[].[PublicIpAddress]' | \
  grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | \
  sed -E | sed -E 's/(.*)/[crdbnodes]\n\1/' > inventory.ini
```

TO DO: 
- create a dynamic inventory to avoid manually modifying the inventory.ini file:w

### Decommissioning the GCP infrastructure  <a name="launch"></a>

To decommision the infrastructure execute the ansibleplaybook _**decom_aws_infra.yml**_ script:

```
ansible-playbook decom_aws_infra.yml
```

## Deploying the Workshop <a name="workshop"></a>

Follow the step below to deploy the workshop assets.

### Setup SSH <a name="ssh"></a>

You need to add the ec2 instances IPs in the `inventory.ini` file to the `~/.ssh/know_host`. The script below adds the IPs in the inventory.ini file to the `$HOME/.ssh/known_hosts`.

&emsp;<code>
./add_2_known_hosts.zsh
</code>

## Deploy Workshop Assets <a name="assets"></a>

- Execute the _**wrkshp_setup.yml**_ playbook

```
% time ansible-playbook --private-key aim_key.pem -i inventory.ini wrkshp_setup.yml

24.97s user 38.52s system 7% cpu 14:27.23 total
```

TO DO:
- crdb workload

## Execute the Workshop Labs<a name="execlabs"></a>

- Go to the [Cockroach_IAM_Workshop](https://github.com/ainfanzon/Cockroach_IAM_Workshop/tree/main/GCP_Colab_notebooks)
- Select the provider (GCP, AWS) folder
- Click on the Lab excercise you want to execute
- At the top of the notebook, click on the **Open in Colab** button at the top of the notebook 
- Click on the **Open in Colab** button at the top of the notebook 
- The notebook is not found in Colab. Authorize to use it with GitHub
- Select the Notebook again to add it to Colab

## Launch the Flask App<a name="execflask"></a>

Create a Python virtual environmet to run the Flask application

- Change to the `~/app` directory

```cd ~/app```

- Install `pyenv`

```curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash```

- Load pyenv automatically by appending the lines below to the `~/.basrc` file.


```
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
```

- Source the `.bashrc` to activate pyenv

```source .bashrc```

- Install a newer python version

```pyenv install 3.12.8```

- Setup a virtual environment

```pyenv virtualenv 3.12.8 myapp```

- Activate the local environment 

```pyenv local myapp```

- Install app requirements

```pip install -r requirements.txt```

### NOTE: Make sure CockroachDB is running and that you have the correct IP address and port number in the **/home/cockroach/app/config.ini** file

- Start the Flask application 

```
echo $(hostname -I) | xargs -I {} python -m flask --app crdb_iam run --host {} --port 8000 --debug
```

- Connect from your browser

```http://35.87.223.79:8000/```

| Role | User |
| ---- | ---- |
|Admin/Super Admin|pocoloco|
|User Manager|roachie|
|Group Manager|crowler|
|Auditor|thumper|
|Helpdesk Support|flora|
|Developer|rollie|
|External User|cookie|

## References <a name="references"></a>

[A simple guide to quickly provisioning AWS resources with Ansible](https://nleiva.medium.com/a-simple-guide-to-quickly-provisioning-aws-resources-with-ansible-35e67ae15b9c)<br>
[Setting Up Ansible the Easier Way and SSH Into AWS EC2](https://medium.com/@elcymarion_her/setting-up-ansible-the-easier-way-and-ssh-into-aws-ec2-7c7ed2766ed6)<br>
[Creating an EC2 instance using Ansible](https://medium.com/@a_tsai5/creating-an-ec2-instance-using-ansible-764cf70015f6)<br>
[Configuring AWS VPC using Ansible](https://rishabh27sharma.medium.com/%EF%B8%8Fconfiguring-aws-vpc-using-ansible-%EF%B8%8F-bbbd7c561a28)<br>
[A simple approach to delete AWS resources with Ansible](https://nleiva.medium.com/a-simple-approach-to-delete-aws-resources-with-ansible-b31c796fa16d)<br>
[A simple guide to quickly provisioning AWS resources with Ansible](https://nleiva.medium.com/a-simple-guide-to-quickly-provisioning-aws-resources-with-ansible-35e67ae15b9c)


