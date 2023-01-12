#!/bin/bash -e
# variables: DOMAIN
IP="$(dig myip.opendns.com @208.67.222.222 +short)"
IP6="$(dig +short -6 myip.opendns.com aaaa @2620:119:35::35)"
SERIAL=$(date '+%Y%m%d')

# Base/NS settings:
echo '$TTL 2h'
echo "@ IN SOA ns1 admin ${SERIAL}01 86400 7200 3600000 172800"
echo '@ IN NS ns1'
echo '@ IN NS ns2'

# Base records
echo "@ IN A ${IP}"
echo "* IN A ${IP}"
echo "@ IN AAAA ${IP6}"
echo "* IN AAAA ${IP6}"

# Generic email settings
echo '_mta-sts IN TXT "v=STSv1; id=1"'
echo '@ IN TXT "v=spf1 a -all"'

# Postmaster dependent settings
echo '_smtp._tls IN TXT "v=TLSRPTv1; rua=mailto:admin@'${DOMAIN}'"'
echo '_dmarc IN TXT "v=DMARC1; p=quarantine; ruf=mailto:admin@'${DOMAIN}'"'

# DKIM
if [ -f "/var/lib/maddy/dkim_keys/${DOMAIN}_default.dns" ]; then
  echo 'default._domainkey IN TXT ('
  echo $(cat /var/lib/maddy/dkim_keys/${DOMAIN}_default.dns | fold -w 80 | sed -e 's/^/"/' | sed -e 's/$/"/')
  echo ')'
fi

# DANE/TLSA
if [ -f "/etc/tls/${DOMAIN}.crt" ]; then
  echo '_25._tcp.mx1 IN TLSA 3 1 1 ('
  echo $(openssl x509 -in /etc/tls/${DOMAIN}.crt -pubkey -noout | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | xxd  -p -u -c 32 | fold -w 80 | sed -e 's/^/"/' | sed -e 's/$/"/')
  echo ')'
fi

if ls /var/acme-challenge/*.${DOMAIN} 1> /dev/null 2>&1; then
  for filename in $(ls /var/acme-challenge/*.${DOMAIN}); do
    cat $filename
  done
fi

if ls /etc/named-config-grug/additional/${DOMAIN} 1> /dev/null 2>&1; then
  for filename in $(ls /etc/named-config-grug/additional/${DOMAIN}); do
    cat $filename
  done
fi
