#!/bin/bash

#exit codes for the application:
#17 help was triggered
#5 invalid option
#1 argument is missing


usage() {
    echo "This is an ssh executor "
    echo "parameters:"
    echo "-f  host file name"
    echo "-s  server name from the host file"
    echo "-h  trigger help message for the script"
}

getBastionIp () {
    BASTION_IP=$(yq -y -c .$SERVER.bastion $HOSTFILE |head -n 1)
    echo "Bastion host for $SERVER is $BASTION_IP"
}

getServerIp () {
    SERVER_IP=$(yq -y -c .$SERVER.ip $HOSTFILE |head -n 1)
    echo "$SERVER ip is the following : $SERVER_IP"
}

generateSshCommand () {
    echo "generating ssh command against bastion $BASTION_IP..."
    echo "ssh -o ProxyCommand="\"ssh -W %h:%p ubuntu@$BASTION_IP\"" -l ubuntu $SERVER_IP"
}

while getopts ":f:s:h" opt; do
  case $opt in
    f)
      echo "-f was triggered, Parameter: $OPTARG" >&2
      HOSTFILE=$OPTARG
      echo "$HOSTFILE was set"
      ;;
    s)
      echo "-s was triggered, Parameter: $OPTARG" >&2
      SERVER=$OPTARG
      echo "$SERVER was set"
      ;;
    h)
      echo "Help was triggered..."
      usage
      exit 17
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      exit 5
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      usage
      exit 1
      ;;
  esac
done

getBastionIp
getServerIp
generateSshCommand
