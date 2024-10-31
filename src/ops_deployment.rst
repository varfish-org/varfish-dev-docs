.. _ops_deployment:

==========
Deployment
==========

::

    # mkdir -p /opt/varfish-download
    # cd /opt/varfish-download
    # wget --no-check-certificate https://file-public.cubi.bihealth.org/transient/varfish/anthenea/varfish-site-data-v1-20210728b-grch37.tar.gz{,.sha256}
    # sha256sum --check varfish-site-data-v1-20210728b-grch37.tar.gz.sha256
    # tar xf varfish-site-data-v1-20210728b-grch37.tar.gz
    # ls volumes
    exomiser  jannovar  minio  postgres  redis  traefik

::

    # git clone https://github.com/varfish-org/varfish-docker-compose.git /opt/varfish-docker-compose
    # cd /opt/varfish-docker-compose
    # mkdir -p .prod
    # mv /opt/varfish-download/volumes .prod/volumes
    # mkdir -p .prod/volumes/{minio,redis,varfish-static,varfish-dynamic}/data

::

    # mkdir -p .prod/secrets
    # echo password >.prod/secrets/db-password
    # echo postgresql://varfish:password@postgres/varfish >.prod/secrets/db-url
    # echo minio-root-password >.prod/secrets/minio-root-password
    # echo minio-varfish-password >.prod/secrets/minio-varfish-password
    # pwgen 100 1 >.prod/secrets/varfish-server-django-secret-key
    # mkdir -p .prod/config/nginx
    # cp utils/nginx/nginx.conf .prod/config/nginx

::
    # DOWNLOAD=reduced-exomes DIR_PREFIX=$PWD/.prod bash download-data.sh

Bring up the system for the first time.
Note that the startup of the web server will be delayed until all migrations are applied.
This will take some time. You might also see some errors during the startup of the web server.

::
    # docker compose pull
    # docker compose up

Do not worry about an error message like the following. This is expected with the first launch and
will be temporary.

::

    # django.db.utils.OperationalError: connection to server at "postgres" (172.18.0.4), port 5432 failed: FATAL:  the database system is starting up

Now go to the website and see issue with self-signed certificate.

To use letsencrypt (server must be reachable from the letsencrypt servers on the internet), use the following docker compose override file based on ``docker-compose.override.yml``.

.. code-block:: diff

    --- docker-compose.override.yml-traefik-le      2024-03-01 11:28:56.279538290 +0100
    +++ docker-compose.override.yml 2024-03-01 15:34:27.847961896 +0100
    @@ -23,7 +23,7 @@
        # EXTRA command lines to make traefik use the config file from bind
        # mount
        # NOTE: update the following line
    -      - "--certificatesresolvers.le.acme.email=YOUR_EMAIL@YOUR_DOMAIN.com"
    +      - "--certificatesresolvers.le.acme.email=admin@examplecom"
        - "--certificatesresolvers.le.acme.storage=/letsencrypt/acme.json"
        - "--certificatesresolvers.le.acme.tlschallenge=true"
        volumes:
    @@ -41,7 +41,7 @@
        - "traefik.http.middlewares.xforward.headers.customrequestheaders.X-Forwarded-Proto=https"
        - "traefik.http.routers.varfish-web.entrypoints=web,websecure"
        - "traefik.http.routers.varfish-web.middlewares=xforward"
    -      - "traefik.http.routers.varfish-web.rule=HostRegexp(`{catchall:.+}`)"
    +      - "traefik.http.routers.varfish-web.rule=HostRegexp(`varfish.example.com`)"
        - "traefik.http.services.varfish-web.loadbalancer.server.port=8080"
        - "traefik.http.routers.varfish-web.tls=true"
        # EXTRA labels lines for varfish-web to enable letsencrypt.

To use a custom certificate, to the following:

::

    mkdir -p .prod/config/traefik/tls
    cp utils/traefik-cert/config/certificates.toml .prod/config/traefik
    # certificate (chain) goes here
    $EDITOR .prod/config/traefik/tls/server.crt
    # certificate private key goes here
    $EDITOR .prod/config/traefik/tls/server.key

Now, launch again:

::

    docker compose up

To launch the containers in daemon mode, use:

::

    docker compose up -d