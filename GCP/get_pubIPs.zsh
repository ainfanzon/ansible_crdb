#!/bin/zsh

while [[ "$#" -gt 0 ]]
do case $1 in
    -d|--directory) dir="$2"
    shift;;
    -h|--help) region="$2"
	    echo "get_pubIP.zsh -d|--directory <ansible-playbook location> -h |--help <this message>"
	    exit
   esac
   shift
done

filename="/Users/ainfanzon/ansible/GCP/$dir/inventory.ini"

if [ -f "$filename" ]; then
  read -q "reply?Are you sure you want to overwrite $filename? [y/N] "
  if [[ "$reply" =~ ^[Yy]$ ]]; then
    rm "$filename"
  else
    echo "Aborting! Keeping the file : $filename intact"
    exit 0
  fi
fi

gcloud compute instances list | awk '{if (NR > 1) print $5}' > $filename

# retrieve the SSH host key for the specified IP address and appends it to the known_hosts file

while IFS= read -r ip; do
  if [[ "$ip" =~ [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} ]]; then
    ssh-keyscan -H "$ip" >> ~/.ssh/known_hosts
  fi
done < $filename
