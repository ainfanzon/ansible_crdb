#!/bin/zsh

while [[ "$#" -gt 0 ]]
do case $1 in
    -d|--directory) dir="$2"
    shift;;
    -n|--name) ec2="$2"
    shift;;
    -r|--region) region="$2"
    shift;;
    -h|--help) region="$2"
	    echo "get_pubIP.zsh -d|--directory <ansible-playbook location> -n|--name <ec2 instance name tag> -r|--region <AWS Region> -h|--help <this message>"
   esac
   shift
done

filename="/Users/ainfanzon/ansible/AWS/$dir/inventory.ini"

if [ -f "$filename" ]; then
  read -q "reply?Are you sure you want to overwrite $filename? [y/N] "
  if [[ "$reply" =~ ^[Yy]$ ]]; then
    rm "$filename"
    aws ec2 describe-instances\
        --filters "Name=tag:Name,Values=$ec2"\
                  "Name=instance-state-name,Values=running"\
	--output text\
	--query "Reservations[].Instances[].[PublicIpAddress]"\
	--profile 337380398238_CRLRevenue\
	--region $region > $filename
    echo "File: $filename has been rewritten"

# retrieve the SSH host key for the specified IP address and appends it to the known_hosts file
    while IFS= read -r ip; do
        if [[ "$ip" =~ [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} ]]; then
            ssh-keyscan -H "$ip" >> ~/.ssh/known_hosts
        fi
    done < $filename
  else
    echo "Aborting: Keeping the file : $filename intact"
    exit 0
  fi
fi
