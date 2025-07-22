#!/usr/bin/env bash
set -e

if [ $# -ne 1 ]; then
  echo "Usage: $0 <PFX_PASSWORD>"
  exit 1
fi

PFX_PASSWORD="$1"

openssl req -subj '/CN=terraform/O=naruby.link/C=BE' -new -newkey rsa:4096 -sha256 -days 730 -nodes -x509 -keyout client.key -out client.crt

# note: the password is intentionally quoted for shell compatibility, the value does not include the quotes
openssl pkcs12 -export -password pass:"$PFX_PASSWORD" -out client.pfx -inkey client.key -in client.crt
