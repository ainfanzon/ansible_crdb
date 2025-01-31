#!/bin/zsh

while IFS= read -r ip; do
  if [[ "$ip" =~ [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} ]]; then
    # retrieve the SSH host key for the specified IP address and appends it to the known_hosts file
    ssh-keyscan -H "$ip" >> ~/.ssh/known_hosts
  fi
done < inventory.ini
