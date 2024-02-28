.. _doc_architecture:

============
Architecture
============

This section describes the overall architecture of VarFish.
Below is a high-level overview of the software components and the interaction with the end user.
Components developed by the team are shown in blue, third-party components are depicted in violet, component groups are in yellow color.

All components run in a Docker Compose environment.
Also, we use the Traefik reverse proxy for routing requests to the correct service (not shown below).

.. mermaid::

    %%{init: {"flowchart": {"htmlLabels": false}} }%%
    flowchart TB
      %% subgraph key [key/legend]
      %%   direction TB
      %%   owned:::owned
      %%   3rd-party:::thirdParty
      %% end
      %% key:::neutral

      subgraph Services [Misc Services]
        direction TB

        annonars[Annonars]:::owned
        mehari[Mehari]:::owned
        viguno[Viguno]:::owned
        nginx[NGINX]:::owned
        fs[(File System)]:::neutral
        cada-prio[CADA-Prio]:::owned
        cadd-rest-api[CADD REST]:::thirdParty
        exomiser[Exomiser]:::thirdParty
        redis[Redis]:::thirdParty

        annonars --> fs
        mehari --> fs
        viguno --> fs
        nginx --> fs
        cada-prio --> fs
        cadd-rest-api --> fs
        exomiser --> fs
      end

      subgraph Core [Server Core]
        direction LR

        varfish-server[VarFish Server]:::owned
        varfish-celeryd[VarFish Celery]:::owned
        postgres[(Postgres)]:::thirdParty
        varfish-server --> varfish-celeryd
        varfish-server --> postgres
        varfish-celeryd --> postgres
      end

      user([end user])

      Core -- "use via HTTP APIs" --> Services
      user --> varfish-server

      classDef neutral fill:white
      classDef owned fill:#c5effc
      classDef thirdParty fill:#e9c5fc

user
  The user uses their web browser to connect to the Varfish Server and interacts with the system.

-----------
Core System
-----------

The following services comprise the Core System that implements the business logic.
This system is aware of the currently logged in user and the information stored in the Postgres database such as the case information.

VarFish Server
    The VarFish Server provides a web-based interface to the software and implements parts of the logic.
    It provides Python/Django web application that serves as the backend for the frontend implementing the product's core functionality.
    The core functionality is implemented in a TypeScript/Vue based single page app (SPA) that itself is served by the backend and then uses REST APIs to communicate with the backend.

Varfish Celery
    We use the Celery task queue system to run jobs in the background that cannot be executed in very short time.
    The Server uses this for running queries, imports.
    Also, Celery is used for scheduling maintenance tasks such as building the in-house database.

Postgres
    We use the PostgreSQL relational database management system to store large parts of the data.
    For large tables, sharding/partitioning is used for improving performance.

.. note::

    The bulk of the data is currently stored in Postgres.
    Work is underway to move this to an internal object storage and run queries on this storage.
    This will allow for more optimized queries and scaling as the Postgres system will not be the single bottleneck anymore.

-----------------------
Misceallaneous Services
-----------------------

There is a list of services that run in the background that the user does not interact with directly.
They provide HTTP-based URLs to the core system then are stateless.
There is no interaction betwen these services.

File System
    These servics generally store their data on the file system.

Annonars
    The Annonars service provides fast access to information specific to genes, seqvars, and strucvars.
    For example, it stores the gene overview information, gene-wise aggregated ClinVar information, and precomputed variant scores.
    Note that the static precomputed gene information includes the link between genes and conditions.
    This service requires large amounts of local storage.

Mehari
    The Mehari service provides computations of variant effects on the transcript level.
    For example, it can predict that a given genomic variant leads to missense or frameshift change on a protein or predict that a structural variant creates a breakpoint in an exon or intron.
    Mehari also provides access to gene transcript information that can be used for rending exon/intron graphics.

Viguno
    The Viguno service provides access to the Human Phenotype Ontology (HPO).
    First, it provides access to the HPO in the common ontology/graph-based fashion, allowing for linking between terms and terms, terms and diseases, etc.
    It also provides simple similarity computations based on information content.
    Second, it provides a full text index on the HPO text content.
    This allows for looking up HPO terms based on their names, aliases, but also descriptions.

NGINX
    The NGING service is a simple HTTP web server that is used for serving static files.
    This is used for serving genome browser tracks, for example.

CADA-Prio
    This is a service that provides similarity predictions between lists of terms and genes based on knowledge graph embeddings.
    It allows for prioritizing genes given the phenotypic description of a patient.

CADD REST
    This is a thin wrapper that provides access to the third-party *CADD scripts*, a software package allowing for the computation of genomic variant scores.
    The CADD score authors provide precomputed scores for all genomic single nucleotide variants and a list of known indel variants.
    For scoring novel variants, this is needed.
    This service requires large amounts of local storage.
    Also, the CADD scripts use various external software such as the ENSEMBL Variant Effect Predictor.

Exomiser
    This is a third-party service implementing several algorithms for computing similarity between lists of phenotype terms and genes.

Redis
    This is a key-value store that is used for caching and storing temporary data by the core services.

.. note::

    These services generally only need little storage space with the exception of Annonars and CADD REST.
    The small amounts of data could be downloaded from a central location on startup in future versions.
    In the case that the large storage requirements of Annonars pose a problem, a migration to object storage backend would need to be implemented.
    Candidates are TileDB.
    CADD REST is more problematic.

.. note::

    With recent versions of the HPO, information content is not very useful for variant prioritization.
