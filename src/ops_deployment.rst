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

    # git clone https://github.com/varfish-org/varfish-docker-compose-ng.git /opt/varfish-docker-compose
    # cd /opt/varfish-docker-compose
    # mkdir -p .prod
    # mv /opt/varfish-download/volumes .prod/volumes
    # mkdir -p .prod/volumes/{minio,varfish-static}/data

::

    # mkdir -p .prod/secrets
    # echo password >.prod/secrets/db-password
    # echo postgresql://varfish:password@postgres/varfish >.prod/secrets/db-url
    # echo minio-root-password >.prod/secrets/minio-root-password
    # echo minio-varfish-password >.prod/secrets/minio-varfish-password
    # rm -
    # mkdir -p .prod/config/nginx
    # cp utils/nginx/nginx.conf .prod/config/nginx

::
    # DOWNLOAD=reduced-exomes DIR_PREFIX=$PWD/.prod bash download-data.sh

Bring up the system for the first time.
Note that the startup of the web server will be delayed until all migrations are applied.
This will take some time.

::
    # docker compose up
