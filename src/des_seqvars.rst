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

.. _des_seqvars_synopsis:

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

.. _des_seqvars_databaseentities:

-----------------
Database Entities
-----------------

.. _des_seqvars_databaseentities_seqvarquerypresets:

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
    Multiple quick presets can be flagged as "auto-execute" to allow for easy launching of all quick presets for an SOP.

In the following ER diagram, only ``SeqvarQueryPresetsXYZ`` is shown as a placeholder for all entities with prefix ``SeqvarQueryPresets*``.

.. mermaid::
    :align: center
    :caption: ER diagram of the ``cases_analysis`` module (part 1: presets).
    :zoom: true

    erDiagram
        Project ||..o{ SeqvarQueryPresetsSet : has
        SeqvarQueryPresetsSet ||..o{ SeqvarQueryPresetsXYZ : has
        SeqvarQueryPresetsSet ||..o{ SeqvarQueryQuickPresets : has
        SeqvarQueryQuickPresets ||..|| SeqvarQueryPresetsXYZ : uses

.. _des_seqvars_databaseentities_seqvarqueries:

Seqvar Queries
==============

``SeqvarQuery``
    A query for seqvars with a label where settings can be adjusted multiple times.

``SeqvarQuerySettings``
    The query settings as passed to the query engine.

``SeqvarQueryExecution``
    The execution of a query with given query settings.

``SeqvarQueryExecutionJob``
    The model interfacing/specizalizing ``bgjobs.BackgroundJob`` for the query execution.
    Log messages are attached as ``bgjobs.BackgroundJobLogEntry`` records to the corresponding ``bgjobs.BackgroundJob``.

The following ER diagram displays the models from this section and their relationship to the ones from :ref:`des_seqvars_databaseentities_seqvarquerypresets` as well as the ``bgjobs`` module from *sodar-core*.
Again, only ``SeqvarQueryPresetsXYZ`` is shown as a placeholder for all entities with prefix ``SeqvarQueryPresets*``.

.. mermaid::
    :align: center
    :caption: ER diagram of the ``cases_analysis`` module (part 2: query).
    :zoom: true

    erDiagram
        CaseAnalysisSession ||..o{ SeqvarQuery : has
        SeqvarQuery ||..|| SeqvarQuerySettings : settings_buffer
        SeqvarQuerySettings ||..o| SeqvarQueryQuickPresets : uses
        SeqvarQuerySettings ||..o| SeqvarQueryPresetsXYZ : uses
        SeqvarQuery ||..o{ SeqvarQueryExecution : has
        SeqvarQueryExecution ||..|| BackgroundJob : has
        BackgroundJob ||..o{ BackgroundJobLogEntry : has
        SeqvarQueryExecution ||..|| SeqvarQuerySettings : current_settings

.. _des_seqvars_databaseentities_seqvarresults:

Seqvar Results
==============

``SeqvarResultSet``
    Stores the results for one ``SeqvarQueryExecution``.
    Also provides information about the data sources used in the result in the field ``datasource_infos``.
    Note that this field is a JSON field using a pydantic model ``DataSourceInfos``.

``SeqvarResultRow``
    Stores one row for one ``SeqvarResultSet``.
    The columns for identifying the variant (genome release, chromosome, chromosome number, start position, end position, reference allele, alternative allele) are stored as separate fields to allow for fast lookup.
    Detailed information such as genes, scores, etc. are stored in JSON fields a pydantic model ``SeqvarResultRowPayload``.

The following ER diagram displays the models from this section and their relationship to the ones from :ref:`des_seqvars_databaseentities_seqvarqueries`.

.. mermaid::
    :align: center
    :caption: ER diagram of the ``cases_analysis`` module (part 3: results).
    :zoom: true

    erDiagram
        SeqvarQueryExecution ||..o| SeqvarResultSet : has
        SeqvarResultSet ||..o{ SeqvarResultRow : has

.. _des_seqvars_databaseentities_seqvarannotation:

Seqvar Annotation
=================

.. caution::

    The following entities are currently in the legacy ``variants`` module.
    We provide their legacy alias in parentheses.

``SeqvarFlag`` (``SmallvariantFlag``)
    Categorial flags and color codes for seqvars.

``SeqvarComment`` (``SmallvariantComment``)
    Free-text comments for seqvars.

``SeqvarAcmgClassification`` (``SmallvariantAcmgClassification``)
    ACMG classification for seqvars.

Note that these entities do not have an explicit foreign key to the variant..
Rather, they all provide genome release, chromosome, start position, reference allele, and alternative allele to refer to the variant they refer to as well as the case and user.

.. mermaid::
    :align: center
    :caption: ER diagram of the ``cases_analysis`` module (part 4: user annotation).
    :zoom: true

    erDiagram
        SeqvarFlag }o..|| User : created_by
        SeqvarComment }o..|| User : created_by
        SeqvarAcmgClassification }o..|| User : created_by
        SeqvarFlag }o..|| Case : is_for
        SeqvarComment }o..|| Case : is_for
        SeqvarAcmgClassification }o..|| Case : is_for

.. _des_seqvars_entities_external:

External Entities
=================

.. _des_seqvars_entities_module:


- ``projectroles.Project`` (from *sodar-core* library)
- ``bgjobs.BackgroundJob`` and ``bgjobs.BackgroundJobLogEntry`` (from *sodar-core* library)
- ``User`` (central user model)
- ``cases_analysis.CaseAnalysisSession``

------------
User Stories
------------

.. caution:: This section is still TODO.

--------------
REST Endpoints
--------------

The ``cases_analysis`` module provides the following endpoints:

**Seqvar Query Presets**

``SeqvarQueryPresetsSet``
    - Create new query preset set based on factory defaults.
    - List all query preset sets for a given project.
    - Retrieve a single query preset set.
    - Update an existing query preset set.
    - Delete an existing query preset set (actually: flag it as deleted).

``SeqvarQueryPresets*`` (for each category)
    - Create a new category preset based on factory defaults.
    - List all category presets for a given preset set.
    - Retrieve a single category preset.
    - Update an existing category preset.
    - Delete an existing category preset (actually: flag it as deleted).

``SeqvarQueryQuickPresets``
    - Create a new quick preset.
    - List all quick presets for a given preset set.
    - Retrieve a single quick preset.
    - Update an existing quick preset.
    - Delete an existing quick preset (actually: flag it as deleted).

**Seqvar Queries**

``SeqvarQuery``
    - Launch (create and execute) all "auto-execute" quick presets for a given preset set.
    - Create a new query with corresponding query settings based on a quick preset.
    - Update a query properties.
    - Delete a query (actually: flag it as deleted).

``SeqvarQuerySettings``
    - Update query settings (only for the ones linked by a query, not the ones from executions).
    - Retrieve query settings for a given query or query execution.

``SeqvarQueryExecution``
    - List all query executions for a given query.
    - Retrieve one query execution together with its execution job.

**Seqvar Results**

``SeqvarResultSet``
    - List the zero to one result sets for a given query execution.

``SeqvarResultRow``
    - Retrieve a page of result rows for a given seqvar result set.
      Sorting is possible.
      Filtration may be possible in the future.

**Seqvar Annotation**

.. caution::

    For now, we re-use the endpoints from the legacy ``variants`` module for seqvar annotation.
