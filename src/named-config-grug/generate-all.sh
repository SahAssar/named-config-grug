#!/bin/bash -e
DOMAIN="$DOMAIN" /etc/named-config-grug/generate-conf.sh > "/etc/named-config-grug/domains.conf"
DOMAIN="$DOMAIN" /etc/named-config-grug/generate-zone.sh > "/etc/named-config-grug/$DOMAIN.zone"
for DOMAIN in $DOMAINS; do
  DOMAIN="$DOMAIN" /etc/named-config-grug/generate-conf.sh >> "/etc/named-config-grug/domains.conf"
  DOMAIN="$DOMAIN" /etc/named-config-grug/generate-zone.sh > "/etc/named-config-grug/$DOMAIN.zone"
done
