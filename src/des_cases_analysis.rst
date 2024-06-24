.. _des_cases_analysis:

=====================
Design: Case Analysis
=====================

This document describes the software design of the ``cases_analysis`` module.

.. _des_cases_analysis_responsibilites:

-----------------------
Module Responsibilities
-----------------------

This module has the following responsibilities:

#. Maintain the database records for
    - case analysis activity for a case and potentially multiple analysist user, and
    - case analysis sessions for per case and analyst user
#. Provide the CRUD operations on these records

.. _des_cases_analysis_synopsis:

--------
Synopsis
--------

Cases may be analyzed multiple times, e.g., when the index is sequenced, then again when the parents are added, and maybe at a later point in time.
Such reanalyses are generally also reimbursed by health insurances.
State may be kept for each analysis activity.
Within one case analysis activity, multiple users may have a case analysis session where we also may need to manage state.

For the initial implementation, we only introduce the necessary entity levels to support multiple activities.
This module is a point for future extension.
We currently only support a single case analysis session for each user and case.
Once a user lists the case analysis or case analysis activities, they are implicitely created.

The analysis of any variant type by a user, e.g., sequence variants, occurs inside a case analysis session.

.. _des_cases_analysis_databaseentities:

-----------------
Database Entities
-----------------

This section describes the database entities maintained by this module.

.. _des_cases_analysis_entities_external:

External Entities
=================

The database entities in this module refer to the following external entities:

- ``User`` (central user model)
- ``cases.Case``

.. _des_cases_analysis_entities_module:

Module Entities
===============

``CaseAnalysis``
    describes the analysis activity of a single case (e.g., first analysis or reanalysis).
    In principle, one ``Case`` can have multiple ``CaseAnalysis`` records, but we restrict ourselves to at most one ``CaseAnalysis`` per ``Case``.
    Increasing the cardinality is a future improvement.
``CaseAnalysisSession``
    describes the analysis of a case by a single user within one ``CaseAnalysis``.
    Again, in principle one ``CaseAnalysis`` can have multiple ``CaseAnalysisSession`` records per ``User``.
    We restrict ourselves to at most one ``CaseAnalysisSession`` per ``CaseAnalysis`` and ``User``.
    Increasing the cardinality is a future improvement.

The following ER diagram shows the relationships between the entities:

.. mermaid::
    :align: center
    :caption: ER diagram of the ``cases_analysis`` module.

    erDiagram
        Case ||..o{ CaseAnalysis : has
        CaseAnalysis ||..o{ CaseAnalysisSession : has
        CaseAnalysisSession }o..|| User : has

.. _des_cases_analysis_user_stories:

------------
User Stories
------------

User lists case analysis activities
    As a user, I want to list all case analysis activities for a case.
    For the initial implementation, only one case analysis will exist and this is implicitely created on listing.

User lists case analysis sessions
    As a user, I want to list all case analysis sessions for a case.
    For the initial implementation, only one case analysis session will exist and this is implicitely created on listing together with its case analysis activity.

.. _des_cases_analysis_activities:

--------------
REST Endpoints
--------------

The ``cases_analysis`` module provides the following endpoints:

List ``CaseAnalysis``
    List all case analysis records.
    This will implicitely create single ``CaseAnalysis`` for the case unless it exists.

List CaseAnalysisSession
    This will implicitely create single ``CaseAnalysisSession`` and corresponding ``CaseAnalysis`` for the ``Case`` and ``User`` unless it exists already.
