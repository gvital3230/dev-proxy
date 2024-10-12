#generates a self-signed certificate for a given domain name
# and updates the traefik tls configuration to use the certificate
cert:
	@if [ -z "$(name)" ]; then \
		echo "Error: 'name' parameter is required"; \
		echo "Example: make cert name=example.com"; \
		exit 1; \
	else \
		./certs/mkcert.sh $(name); \
		./config/update_tls.sh; \
	fi
