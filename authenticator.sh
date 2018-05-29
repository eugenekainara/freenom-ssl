#!/bin/sh
hash jq || exit 1

API_USER=${API_USER}
API_PASSWORD=${API_PASSWORD}
DOMAIN=${CERTBOT_DOMAIN}
if [[ ! -f /tmp/domain_json ]] || [[ $(( (`date +%s` - `stat -L -c %Y $filename`) > (30) )) ]];then
  fdu domain ls $API_USER $API_PASSWORD -f JSON > /tmp/all_domains.json
fi

ALL_DOMAINS=$(cat /tmp/all_domains.json | jq -r .[].name)

if $(echo "$ALL_DOMAINS" | grep -q "$DOMAIN" );then
  ROOT_DOMAIN="$DOMAIN"
  SUB_DOMAIN="_acme-challenge"
else
  ROOT_DOMAIN=${DOMAIN#*.*}
  SUB_DOMAIN=_acme-challenge.${DOMAIN%%.*}
fi

fdu record update ${API_USER} ${API_PASSWORD} ${ROOT_DOMAIN} -n ${SUB_DOMAIN} -l 300 -t TXT -a ${CERTBOT_VALIDATION}

sleep 1m
