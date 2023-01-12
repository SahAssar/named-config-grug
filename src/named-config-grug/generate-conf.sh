#!/bin/bash -e
# variables: DOMAIN
echo 'zone "'$DOMAIN'" { type master; file "/etc/named-config-grug/'$DOMAIN'.zone"; };'
