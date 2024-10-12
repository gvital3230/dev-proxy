#!/bin/bash

# Define the directory containing the certificates and the configuration file
BASE=$(dirname "$0")
CERT_DIR="$BASE/../certs/"
CONFIG_FILE="$BASE/tls.yml"

# Function to find certificate and key pairs
find_certificates() {
  cert_pairs=()
  for cert_file in "$CERT_DIR"*.crt; do
    base_name=$(basename "$cert_file" .crt)
    key_file="${CERT_DIR}${base_name}.key"
    if [ -f "$key_file" ]; then
      cert_pairs+=("$cert_file:$key_file")
    fi
  done
}

# Function to write YAML config
write_yaml() {
  echo "tls:" >"$CONFIG_FILE"
  echo "  certificates:" >>"$CONFIG_FILE"

  for pair in "${cert_pairs[@]}"; do
    cert_file=$(basename "${pair%%:*}")
    key_file=$(basename "${pair##*:}")
    echo "    - certFile: \"/certs/$cert_file\"" >>"$CONFIG_FILE"
    echo "      keyFile: \"/certs/$key_file\"" >>"$CONFIG_FILE"
  done
}

# Main script execution
find_certificates
write_yaml

echo "Configuration file updated successfully!"
