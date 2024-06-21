.. _des_seqvars:

===============
Design: Seqvars
===============

This document describes the software design of the ``seqvars`` module.

.. _des_seqvars_responsibilites:

-----------------------
Module Responsibilities
-----------------------

This module has the following responsibilities:

#. Manage sequence variant (seqvar) query query presets database records as well as factory defaults
#. Manage the database records related to sequence variant analysis activies by the users
    - Running seqvar queries
    - Launching the backend query engine jobs
    - Store the query job results
    - Allow users to fetch the query jobs results in a paginated and ordered manner
    - Allow users to perform sequence variant annotation on the results in the form of flags, color codes, and ACMG classification

.. _des_cases_analysis_synopsis:

--------
Synopsis
--------

From a bird's eye view, users prepare queries, e.g., with thresholds on population frequency, select certain variant consequences, and genotype patterns.
Each value in these queries can be set manually but users can also store **category presets**, e.g., the category "population frequency" or "variant locus".

For preparing the seqvar analysis, users can manage query presets for each category within projects and organize them into preset sets.
User can select one presets item from each category and organize these into **quick presets**.
Such quick preset sets are usually created with in a structured fashion, following a clinical :term:`SOP` and with a given hypothesis in mind.
For example, quick presets may be "recessive inheritance" or "mitochondriopathy".

Analysis of seqvars occurs within the case analysis session of a case and user.

.. _des_cases_analysis_databaseentities:

-----------------
Database Entities
-----------------

This section describes the database entities maintained by this module.

.. _des_cases_analysis_entities_external:

External Entities
=================

.. _des_cases_analysis_entities_module:


- ``projectroles.Project`` (from *sodar-core* library)
- ``User`` (central user model)
- ``cases_analysis.CaseAnalysisSession``

Module Entities
===============

------------
User Stories
------------

--------------
REST Endpoints
--------------
