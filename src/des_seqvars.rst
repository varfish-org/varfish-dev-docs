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

Seqvar Query Presets
====================

From a bird's eye view, users prepare queries, e.g., with thresholds on population frequency, select certain variant consequences, and genotype patterns.
Each value in these queries can be set manually but users can also store **category presets**, e.g., the category "population frequency" or "variant locus".

For preparing the seqvar analysis, users can manage query presets for each category within projects and organize them into **preset sets**.
User can select one presets item from each category and organize these into **quick presets**.
Such quick preset sets are usually created with in a structured fashion, following a clinical :term:`SOP` and with a given hypothesis in mind.
For example, quick presets may be "recessive inheritance" or "mitochondriopathy".

Seqvar Queries
==============

Analysis of seqvars occurs within the case analysis session of a case and user.
Within each session, users maintain multiple named queries, e.g., one for each hypothesis which usually corresponds to the quick presets in the currently used preset set.
Users can quickly create new queries from existing quick presets or create one query for each quick preset in a preset set.
Each query has some simple data such as its label but the main information are selectected category presets for each category, and a "buffer" with the current full query settings.
The user interface allows the user to easily identify changes in query settings and the selected category presets.

Users can launch query executions for each query with its current setting.
The query execution holds an (almost immutable) copy of the query settings and the state for the execution of the query in the background.
For execution, a new job is put into a background queue and eventually picked up by a worker to perform the query execution, an update the state.
Once complete, a new query result set with resulting rows is created in the database.

Seqvar Results
==============

The user can then display the query result set, sort it by its columns, and paginated through the result rows.
Users can also manipulate the query result table columns by switching visibility of columns, column order, and column width.
These settings are stored in the column presets of the query settings of the currently displayed query execution.

Seqvar Annotation
=================

Users can annotate result variants in different ways.

- Variant flagging and color coding.
- Variant comments with free-text comments.
- ACMG classification of the variant (manual pick fulfilled criteria and upgrade/downgrade severity).

.. _des_cases_analysis_databaseentities:

-----------------
Database Entities
-----------------

Seqvar Query Presets
====================

This section describes the database entities maintained by this module.

``SeqvarQueryPresetsSet``
    Container for the category presets and quick presets.

``SeqvarQueryPresetsFrequency``, ``SeqvarQueryPresetsConsequence``, ``SeqvarQueryPresetsLocus``, ``SeqvarQueryPresetsPhenotypePrio``, ``SeqvarQueryPresetsVariantPrio``, ``SeqvarQueryPresetsMisc``, ``SeqvarQueryPresetsColumns``
    Category presets in the categories frequency, consequence, locus, phenotype priorization, variant priorization, miscellaneous, and result table column configuration.
    Examples would be "recessive relaxed" or "autosomal strict" frequency.

``SeqvarQueryQuickPresets``
    Select one category presets of each category and make it available as a quick preset.
    Examples would be "recessive inheritance" or "mitochondriopathy".

In the following ER diagram, only ``SeqvarQueryPresetsXYZ`` is shown as a placeholder for all entities with prefix ``SeqvarQueryPresets*``.

.. mermaid::
    :align: center
    :caption: ER diagrem of the ``cases_analysis`` module.
    :zoom: true

    erDiagram
        Project ||..o{ SeqvarQueryPresetsSet : has
        SeqvarQueryPresetsSet ||..o{ SeqvarQueryPresetsXYZ : has
        SeqvarQueryPresetsSet ||..o{ SeqvarQueryQuickPresets : has
        SeqvarQueryQuickPresets ||..|| SeqvarQueryPresetsXYZ : uses


Seqvar Queries
==============

``SeqvarQuery``
    A query for seqvars with a label where settings can be adjusted multiple times.

``SeqvarQuerySettings``
    The query settings as passed to the query engine.

``SeqvarQueryExecution``
    The execution of a query with given query settings.

Seqvar Results
==============

Seqvar Annotation
=================

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
