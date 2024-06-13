.. _dev_install:

======================
Developer Installation
======================


The VarFish installation for developers should be set up differently from the installation for production use.

The reason being is that the installation for production use runs completely in a Docker environment.
All containers are assigned to a Docker network that the host by default has no access to, except for the reverse proxy that gives access to the VarFish webinterface.

The developers installation is intended not to carry the full VarFish database such that it is light-weight and fits on a laptop.
We advise to install the services not running in a Docker container.

Please find the instructions for the Windows installation at the end of the page.


.. _dev_install_postgres:

----------------
Install Postgres
----------------

Follow the instructions for your operating system to install `Postgres <https://www.postgresql.org>`__.
Make sure that the version is 12 (11, 13 and 14 also work).
Ubuntu 20 already includes postgresql 12.
In case of older Ubuntu versions, this would be.

.. code-block:: bash

    sudo apt install postgresql-12


Adapt the postgres configuration file, for postgres 14 this would be:

.. code-block:: bash

    sudo sed -i \
      -e 's/.*max_locks_per_transaction.*/max_locks_per_transaction = 1024 # min 10/' \
      /etc/postgresql/14/main/postgresql.conf


.. _dev_install_redis:

-------------
Install Redis
-------------

`Redis <https://redis.io>`_ is the broker that celery uses to manage the queues.
Follow the instructions for your operating system to install Redis.
For Ubuntu, this would be:

.. code-block:: bash

    sudo apt install redis-server


.. _dev_install_python_pipenv:

---------------------
Install Python Pipenv
---------------------

We use `pipenv <https://pipenv.pypa.io/en/latest/>`__ for managing dependencies.
The advantage over ``pip`` is that also the versions of "dependencies of dependencies" will be tracked in a ``Pipfile.lock`` file.
This allows for better reprocubility.

Also, note that VarFish is developed using Python 3.10+ only.
To install Python 3.10+, you can use `pyenv <https://github.com/pyenv/pyenv>`__.
If you already have Python 3.10 (check with ``python --version`` then you can skip this step).

.. code-block:: bash

    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc
    exec $SHELL
    pyenv install 3.10
    pyenv global 3.10

Now, install the latest version of pip and pipenv:

.. code-block:: bash

    pip install --upgrade pip pipenv


.. _dev_install_clone_git:

--------------------
Clone git repository
--------------------

Clone the VarFish Server repository and switch into the checkout.

.. code-block:: bash

    git clone --recursive https://github.com/varfish-org/varfish-server
    cd varfish-server


.. _dev_install_frontend_deps:

-----------------------------
Install Frontend Dependencies
-----------------------------


Execute the ``utils/install_frontend_os_dependencies.sh`` script to install OS package dependencies of Node/TypeScript packages.
Essentially, this installs NodeJS in a current version.
The script was written for Ubuntu, you will have to adjust it for other OS.

.. code-block:: bash

    sudo bash utils/install_frontend_os_dependencies.sh

Now, you can install the Node/TypeScript dependencies as follows:

.. code-block:: bash

    ## go into frontend directory
    cd frontend
    ## setup pipenv environment
    make deps

.. _dev_prepare_frontend:

-------------------------
(Optional) Build Frontend
-------------------------

Execute the following command to build the frontend.
This is not required as during development, the Vite server will create the necessary files on the fly.

.. code-block:: bash

    ## go into frontend directory
    cd frontend
    ## setup pipenv environment
    make serve


.. _dev_serve_frontend:

---------------
Server Frontend
---------------

You can now start the Vite server to serve the Vite/Typescript based frontend.
Note that this is not accessible on its own as it is embedded into websites served by the backend.

.. code-block:: bash

    ## go into frontend directory
    cd frontend
    ## start server
    make serve

For the remainder of the installation steps, use a new terminal and keep the frontend server running.


.. _dev_install_backend_deps:

----------------------------
Install Backend Dependencies
----------------------------

Execute the ``utils/install_backend_os_dependencies.sh`` script to install OS package dependencies of Python packages.
The script was written for Ubuntu, you will have to adjust it for other OS.

.. code-block:: bash

    sudo bash utils/install_backend_os_dependencies.sh

Now, you can install the Python dependencies as follows:

.. code-block:: bash

    ## go into backend directory
    cd backend
    ## setup pipenv environment
    make deps

Afterwards, you can either enter the Pipenv environment or directly run helper ``make`` commands.

.. code-block:: bash

    ## go into backend directory
    cd backend
    ## start pipenv shell
    pipenv shell
    ## OR
    make lint
    make format
    make test


.. _dev_install_setup_db:

--------------
Setup Database
--------------

Use the tool provided in ``utils/`` to set up the database.
The name for the database should be ``varfish`` (create new user: yes, name: varfish, password: varfish).

.. code-block:: bash

    bash utils/setup_database.sh


.. _dev_prepare_backend:

---------------
Prepare Backend
---------------

Next, create a ``backend/.env`` file with the following content.

.. code-block:: bash

    export DATABASE_URL="postgres://varfish:varfish@127.0.0.1/varfish"
    export CELERY_BROKER_URL=redis://localhost:6379/0
    export PROJECTROLES_ADMIN_OWNER=root
    export DJANGO_SETTINGS_MODULE=config.settings.local

To create the tables in the VarFish database, run the ``migrate`` command.
This step can take a few minutes.

.. code-block:: bash

    ## go into backend directory
    cd backend
    ## run migrations
    make migrate

Once done, create a superuser for your VarFish instance.
By default, the VarFish root user is named ``root`` (the setting can be changed in the ``.env`` file with the ``PROJECTROLES_ADMIN_OWNER`` variable).

.. code-block:: bash

    cd backend
    pipenv run python manage.py createsuperuser

Last, download the icon sets for VarFish and make scripts, stylesheets and icons available.

.. code-block:: bash

    make geticons
    make collectstatic


.. _dev_database_import:

---------------
Database Import
---------------

First, download the pre-build database files that we provide and unpack them.
Please make sure that you have enough space available.
The packed file consumes 31 Gb.
When unpacked, it consumed additional 188 GB.

.. code-block:: bash

    cd /plenty/space
    wget https://file-public.bihealth.org/transient/varfish/varfish-server-background-db-20201006.tar.gz{,.sha256}
    sha256sum -c varfish-server-background-db-20201006.tar.gz.sha256
    tar xzvf varfish-server-background-db-20201006.tar.gz

We recommend to exclude the large databases: frequency tables, extra annotations and dbSNP.
Also, keep in mind that importing the whole database takes >24h, depending on the speed of your disk.

This is a list of the possible imports, sorted by its size:

===================  ====  ==================  =============================
Component            Size  Exclude             Function
===================  ====  ==================  =============================
gnomAD_genomes       80G   highly recommended  frequency annotation
extra-annos          50G   highly recommended  diverse
dbSNP                32G   highly recommended  SNP annotation
thousand_genomes     6,5G  highly recommended  frequency annotation
gnomAD_exomes        6,0G  highly recommended  frequency annotation
knowngeneaa          4,5G  highly recommended  alignment annotation
clinvar              3,3G  highly recommended  pathogenicity classification
ExAC                 1,9G  highly recommended  frequency annotation
dbVar                573M  recommended         SNP annotation
gnomAD_SV            250M  recommended         SV frequency annotation
ncbi_gene            151M                      gene annotation
ensembl_regulatory   77M                       frequency annotation
DGV                  43M                       SV annotation
hpo                  22M                       phenotype information
hgnc                 15M                       gene annotation
gnomAD_constraints   13M                       frequency annotation
mgi                  10M                       mouse gene annotation
ensembltorefseq      8,3M                      identifier mapping
hgmd_public          5,0M                      gene annotation
ExAC_constraints     4,6M                      frequency annotation
refseqtoensembl      2,0M                      identifier mapping
ensembltogenesymbol  1,6M                      identifier mapping
ensembl_genes        1,2M                      gene annotation
HelixMTdb            1,2M                      MT frequency annotation
refseqtogenesymbol   1,1M                      identifier mapping
refseq_genes         804K                      gene annotation
mim2gene             764K                      phenotype information
MITOMAP              660K                      MT frequency annotation
kegg                 632K                      pathway annotation
mtDB                 336K                      MT frequency annotation
tads_hesc            108K                      domain annotation
tads_imr90           108K                      domain annotation
vista                104K                      orthologous region annotation
acmg                 16K                       disease gene annotation
===================  ====  ==================  =============================

You can find the ``import_versions.tsv`` file in the root folder of the package.
This file determines which component (called ``table_group`` and represented as folder in the package) gets imported when the import command is issued.
To exclude a table, simply comment out (``#``) or delete the line.
Excluding tables that are not required for development can reduce time and space consumption.
Also, the GRCh38 tables can be excluded.

A space-consumption-friendly version of the file would look like this

.. code-block::

    build	table_group	version
    GRCh37	acmg	v2.0
    #GRCh37	clinvar	20200929
    #GRCh37	dbSNP	b151
    #GRCh37	dbVar	latest
    GRCh37	DGV	2016
    GRCh37	ensembl_genes	r96
    GRCh37	ensembl_regulatory	latest
    GRCh37	ensembltogenesymbol	latest
    GRCh37	ensembltorefseq	latest
    GRCh37	ExAC_constraints	r0.3.1
    #GRCh37	ExAC	r1
    #GRCh37	extra-annos	20200704
    GRCh37	gnomAD_constraints	v2.1.1
    #GRCh37	gnomAD_exomes	r2.1
    #GRCh37	gnomAD_genomes	r2.1
    #GRCh37	gnomAD_SV	v2
    GRCh37	HelixMTdb	20190926
    GRCh37	hgmd_public	ensembl_r75
    GRCh37	hgnc	latest
    GRCh37	hpo	latest
    GRCh37	kegg	april2011
    #GRCh37	knowngeneaa	latest
    GRCh37	mgi	latest
    GRCh37	mim2gene	latest
    GRCh37	MITOMAP	20200116
    GRCh37	mtDB	latest
    GRCh37	ncbi_gene	latest
    GRCh37	refseq_genes	r105
    GRCh37	refseqtoensembl	latest
    GRCh37	refseqtogenesymbol	latest
    GRCh37	tads_hesc	dixon2012
    GRCh37	tads_imr90	dixon2012
    #GRCh37	thousand_genomes	phase3
    GRCh37	vista	latest
    #GRCh38	clinvar	20200929
    #GRCh38	dbVar	latest
    #GRCh38	DGV	2016

To perform the import, issue:

.. code-block:: bash

    cd backend
    pipenv python manage.py import_tables \
      --tables-path /plenty/space/varfish-server-background-db-20201006

Performing the import twice will automatically skip tables that are already
imported. To re-import tables, add the ``--force`` parameter to the command:

.. code-block:: bash

    cd backend
    pipenv python manage.py import_tables \
      --tables-path varfish-db-downloader --force


.. _dev_run_server_celery:

---------------------
Run Server and Celery
---------------------

Now, open two terminals and start the VarFish server and the celery server.

.. code-block:: bash

    ## in terminal 1
    make serve
    ## in a separate terminal 2
    make celery

Continue the tutorial in a new terminal.


.. _dev_install_backing_services:

---------------------------
Install Annotation Services
---------------------------

VarFish uses a number of internal annotation services that you need to install as well.
The instructions below will provide you with a development subset that contains information on all genes but variant information on genes BRCA1 and TGDS only.

First, install Docker and docker compose `following the official manual <https://docs.docker.com/compose/install/linux/>`__.

Then, install the ``s5cmd`` tool for downloading data later on.

.. code-block:: bash

    wget -O /tmp/s5cmd_2.1.0_Linux-64bit.tar.gz \
      https://github.com/peak/s5cmd/releases/download/v2.1.0/s5cmd_2.1.0_Linux-64bit.tar.gz
    tar -C /tmp -xf /tmp/s5cmd_2.1.0_Linux-64bit.tar.gz
    sudo cp /tmp/s5cmd /usr/local/bin/

Next, follow the `instructions on the varfish-docker-compose-ng README <https://github.com/varfish-org/varfish-docker-compose-ng?tab=readme-ov-file#checkout-and-configure>`__.

.. code-block:: bash

    ## clone
    git clone https://github.com/varfish-org/varfish-docker-compose-ng.git

    ## go into directory
    cd varfish-docker-compose-ng

    ## create volumes directories
    mkdir -p .dev/volumes/{minio,varfish-static}/data
    ## create secrets
    mkdir -p .dev/secrets
    echo password >.dev/secrets/db-password
    echo postgresql://varfish:password@postgres/varfish >.dev/secrets/db-url
    echo minio-root-password >.dev/secrets/minio-root-password
    echo minio-varfish-password >.dev/secrets/minio-varfish-password
    ## ensure that pwgen is installed first
    pwgen
    ## generate a 100 character secret
    pwgen 100 1 >.prod/secrets/varfish-server-django-secret-key
    ## copy environment file
    cp env.tpl .env
    ## copy docker-compose override file
    cp docker-compose.override.yml-dev docker-compose.override.yml

    ## setup some configuration
    mkdir -p .dev/config/nginx
    cp utils/nginx/nginx.conf .dev/config/nginx

    ## download dev data
    bash download-data.sh

Now you can take up the backing services using:

.. code-block:: bash

    docker compose up


.. _dev_try_it_out:

----------
Try It Out
----------

You now have the system services Postgres and Redis running.
You also have frontend vite development service, the backend Django server, and the Celery worker running.
You can now try out VarFish by going to `localhost:8080 <http://localhost:8080/>`__ and login with the superuser account you created above.


.. _dev_install_windows:

----------------------
Installation (Windows)
----------------------

The setup was done on a recent version of Windows 10 with Windows Subsystem for Linux Version 2 (WSL2).


.. _dev_install_windows_wsl2:

Installation WSL2
=================

Following [this tutorial](https://www.omgubuntu.co.uk/how-to-install-wsl2-on-windows-10) to install WSL2.

- Note that the whole thing appears to be a bit convoluted, you start out with `wsl.exe --install`
- Then you can install latest LTS Ubuntu 22.04 with the Microsoft Store
- Once complete, you probably end up with a WSL 1 (one!) that you can conver to version 2 (two!) with `wsl --set-version Ubuntu-22.04 2` or similar.
- WSL2 has some advantages including running a full Linux kernel but is even slower in I/O to the NTFS Windows mount.
- Everything that you do will be inside the WSL image.


.. _dev_install_docker_desktop:

Installation Docker Desktop
===========================

Follow the `Install Docker Desktop <https://docs.docker.com/desktop/install/windows-install/>`__ instructions.
Then, ensure that the Docker Engine is running.


.. _dev_install_windows_os_deps:

Install OS Dependencies
=======================

.. code-block:: bash

    ## install dependencies
    sudo apt install libsasl2-dev python3-dev libldap2-dev libssl-dev gcc make rsync
    ## install postgres and redis
    sudo apt install postgresql postgresql-server-dev-14 postgresql-client redis
    ## start postgres, must be done after each WSL2 start
    sudo service postgresql start
    sudo service postgresql status
    ## start redis, must be done after each WSL2 start
    sudo service redis-server start
    sudo service redis-server status
    ## update postgres configuration and restart, only do this once
    sudo sed -i -e 's/.*max_locks_per_transaction.*/max_locks_per_transaction = 1024 # min 10/' /etc/postgresql/14/main/postgresql.conf
    sudo service postgresql restart

Create a postgres user `varfish` with password `varfish` and a database.

.. code-block::

    sudo -u postgres createuser -s -r -d varfish -P
    [enter varfish as password]
    sudo -u postgres createdb --owner=varfish varfish

From here on, you can follow the instructions for the Linux installation, starting at `ref:dev_install_python_pipenv`.
