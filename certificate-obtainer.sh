#!/bin/sh

API_USER=${1:-$API_USER}
API_PASSWORD=${2:-$API_PASSWORD}
DOMAIN_LIST=${3:-$DOMAIN_LIST}
USER_EMAIL=${4:-$API_USER}

if [ -z $API_USER ] || [ -z $API_PASSWORD ] || [ -z $DOMAIN_LIST ];then
  echo "Not all arguments specified."
  exit 1
fi

for domain in $(echo $DOMAIN_LIST | tr "," " ")
do
domain_string="$domain_string-d $domain "
done

certbot certonly --manual --manual-auth-hook /authenticator.sh \
  --manual-public-ip-logging-ok --preferred-challenges=dns --agree-tos \
  --email ${USER_EMAIL} $domain_string
