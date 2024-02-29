.. _doc_repooverview:

===============
GitHub Overview
===============

This section gives an overview of the GitHub repositories relevant to the VarFish project.
All are in ``varfish-org``, version 2.0 of the Apache license is used.

.. _doc_repooverview_direct_importance:

-----------------
Direct Importance
-----------------

The following repositories are directly important and provide functionality used by the system.

.. list-table::
    :header-rows: 1

    * - name
      - license
      - synopsis
    * - annonars
      - MIT
      - precomputed variant, region, and gene annotation
    * - annonars-data-clinvar
      - MIT
      - ClinVar data builds for annonars
    * - cada-prio
      - MIT
      - phenotype-based prioritization based on knowledge graph embeddings
    * - cadd-rest-api
      - MIT
      - REST API wrapper for CADD-scripts
    * - cadd-rest-api-mock
      - MIT
      - mocking the CADD REST API server for VarFish development
    * - clinvar-data-jsonl
      - MIT
      - weekly ClinVar releases as JSONL plus useful aggregation
    * - clinvar-this
      - MIT
      - ClinVar submission and XML dump file parsing
    * - mehari
      - MIT
      - transcript effect annotation and tx model information
    * - mehari-data-tx
      - MIT
      - transcript data builds for mehari
    * - varfish-db-downloader
      - MIT
      - Snakemake workflow to download public data
    * - varfish-cli
      - MIT
      - command line interface for VarFish REST API
    * - varfish-dev-docs
      - MIT
      - documentation for developers
    * - varfish-docker-compose-ng
      - MIT
      - setup VarFish with Docker Compose
    * - varfish-server
      - MIT
      - VarFish web server
    * - varfish-server-worker
      - MIT
      - heavy lifting in varfish-server written in Rust
    * - viguno
      - Apache
      - HPO ontology access and full-text search


.. _doc_repooverview_indirect_importance:

-------------------
Indirect Importance
-------------------

The following are dependencies of the one in :ref:`doc_repooverview_direct_importance` maintained by us and housekeeping tools.

.. list-table::
    :widths: 30 20 50
    :header-rows: 1

    * - name
      - license
      - synopsis
    * - biocommons-bioutils-rs
      - Apache
      - (partial) port of biocommons/bioutils to Rust
    * - hgvs-rs
      - Apache
      - port of biocommons/hgvs to the Rust programming language
    * - rocksdb-utils-lookup
      - Apache
      - utility library for using RocksDB as lookup tables
    * - seqrepo-rs
      - Apache
      - a port of biocommons/seqrepo to the Rust programming language


.. _doc_repooverview_experimental:

------------
Experimental
------------

The following contain experimental, under development, or unfinished code.

.. list-table::
    :header-rows: 1

    * - name
      - license
      - synopsis
    * - scarus
      - Apache
      - automated evaluation of ACMG rules
    * - varfish-clinical-beacon-client
      - MIT
      - client for clinical beacons API proof of concept
    * - varfish-wf-validation
      - MIT
      - Snakemake workflow for automated validation
    * - varfish-cli-ng
      - MIT
      - VarFish CLI based on aws-smithy


.. _doc_repooverview_legacy:

------
Legacy
------

The following are legacy repositories.

.. list-table::
    :header-rows: 1

    * - name
      - license
      - synopsis
    * - varfish-course-scripts
      - MIT
      - scripts for generating the data used in the VarFish course
    * - varfish-wf-queries
      - MIT
      - VarFish (Snakemake) Client Workflow for Querying Snakemake
    * - varfish-docker-compose
      - MIT
      - legacy setup VarFish as using Docker Compose
    * - varfish-anno
      - MIT
      - convert annotation database files to Var:fish: import format
    * - varfish-installer
      - MIT
      - use varfish-docker-compose instead
    * - varfish-annotator
      - MIT
      - annotate variants for import into VarFish server
    * - varfish-data-igsr
      - MIT
      - repository for building IGSR data sets for use in VarFish
