# Private Link Demo

## Step 1

Create a Cockroach Cloud Advanced or Standard Cluster

## Step 2

Execute the `dply_aws_infra.yml` ansible playbook

```
time ansible-playbook dply_aws_infra.yml

...

ansible-playbook dply_aws_infra.yml -vvv  3.59s user 1.92s system 19% cpu 28.962 total
```

**NOTE** In the AWS Console, validate all the infrastructure components were created.

## Step 3

Save the Public IP of the ec2 instance in the `inventory.ini` file
```
privateLink % aws ec2 describe-instances\
        --filters 'Name=tag:Name,Values=aim-pl-cc-dedicated'\
                  'Name=instance-state-name,Values=running'\
        --output text\
        --query 'Reservations[].Instances[].[PublicIpAddress]'\
        --profile 337380398238_CRLRevenue\
        --region us-west-2 > inventory.ini
```

## Step 4

Configure and deploy CRDB 

```
time ansible-playbook --private-key aim-pl-key.pem -i inventory.ini crdb_setup.yml --skip-tags "install_devtools"
```

## Step 5

Validate the Private Link endpoint

- Make sure the service name is the same that the one in the **vars.yml** file
- validate the endpoint
```
Your endpoint has been accepted. Once your endpoint status changes to Available in the AWS console, you will be able to connect.
```

```
ansible-playbook --private-key aim-pl-key.pem -i inventory.ini crdb_setup.yml  7.21s user 8.71s system 4% cpu 6:12.33 total
```

## Step 6

Test private link connection

- login to the ec2 instance as roachie/roachfan
- Download the certificate

