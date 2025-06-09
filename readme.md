# Development Proxy

This project serves as a proxy for various Docker Compose projects during the local development process. It allows to organise simple service mesh for development purposes. To be able to use multiple docker compose projects active at the same time and to remove limitations of usage of ports 80 and 443 on host machine by multiple applications.

It provides also SSL termination, so application project environment should not care about it. It can expose any port that is needed to it  and just need to register itself in this proxy to became available on 443 port of host machine.

![[./doc/architecture.drawio.svg]](./doc/architecture.drawio.svg)

## Getting Started

To set up and run the proxy, follow these steps:

1. Clone the repository and navigate into the project directory.
2. Start the Docker Compose stack:

    ```bash
    docker-compose up -d
    ```

## Adding New Services

This docker compose stack provides network `app-dev-mesh` which all services **MUST** connect to. To add a new service, follow these rules in your service's docker-compose definition:

1. Use following network as default:

    ```yaml
    networks:
      default:
        name: app-dev-mesh
        external: true
    ```

2. Add following labels to your service:

    ```yaml
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.<service-name>.rule=Host(`<service-name>.local`)"
      - "traefik.http.routers.<service-name>.entrypoints=websecure"
    ```

3. To add CORS which allows any origin headers to your service, you can use predefined middleware `cors-allow-all`:

    ```yaml
    labels:
      - "traefik.http.routers.widgets-widgets.middlewares=cors-allow-all"
    ```

## Using Custom TLS Certificates

It is often annoying to work with self-signed certificates in development. And to confirm every time that you trust the certificate in your browser.
To avoid it you can generate self-signed SSL certificates and then use them as trusted in your system. Certificates are located in `cert` directory.

If you want to issue a new certificate for a domain, use the following command:

```bash
make cert name=<your-service-dns-name>
```

This will:

- Generate the certificate.
- Update the proxy configuration automatically.

After the certificate is generated, follow the instructions below to trust the certificate on your system.

## Trusting the TLS Certificate

Once the certificate is generated, it can be found in the `cert` directory. You will need to add it as a trusted certificate on your operating system.

### MacOS

1. Open Keychain Access.
2. Go to File > Import Items and select the .crt certificate you generated.
3. In the System keychain, find the newly added certificate.
4. Right-click it, select Get Info.
5. Expand the Trust section, set When using this certificate to Always Trust.
6. Close the window and enter your admin password to confirm.
7. Restart your browser to apply the changes.

### Linux

1. Copy the .crt file to `/usr/local/share/ca-certificates/`:

```bash
sudo cp <your-certificate>.crt /usr/local/share/ca-certificates/
```

2. Update the CA certificates:

```bash
sudo update-ca-certificates
```

3. Restart your browser to apply the changes.

Note: Some Linux distributions may require restarting the system for the changes to take effect.

### Windows

1. Press Windows + R and type certmgr.msc to open the Certificate Manager.
2. Navigate to Trusted Root Certification Authorities > Certificates.
3. Right-click and choose All Tasks > Import.
4. Use the import wizard to select the .crt certificate file.
5. Once the import is complete, restart your browser to apply the changes.
