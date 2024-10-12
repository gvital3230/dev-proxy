#!/bin/bash

NAME="$1"
BASE=$(dirname "$0")
KEY="$BASE/$NAME.key"
CRT="$BASE/$NAME.crt"

openssl req -newkey rsa:2048 -nodes -keyout "$KEY" -x509 -sha256 -days 1825 \
  -subj "/C=US/ST=WA/L=SEATTLE/O=Development/OU=Development/CN=*.$NAME" \
  -addext "subjectAltName = DNS:$NAME, DNS:*.$NAME" \
  -out "$CRT"

## Required so docker can access this (for now at least)
chmod go+r "$KEY"
