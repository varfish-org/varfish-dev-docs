.. _des_overview:

================
Design: Overview
================

This document provides an overview of the software modules of VarFish Server described in the **Design** section.
As mentioned in the chapter :ref:`doc_architecture`, VarFish Server consists of a Frontend (TypeScript/Vue3) and a Backend (Python/Django) component.

The frontend generally needs a corresponding component in the backend, and the components communicate via REST APIs calls.
The backend is implemented with Django Rest Framework (DRF) and an API specification is created as OpenAPI v3 from the DRF views.
For the frontend, we generate TypeScript client API libraries from these definitions, ensuring type-safe communication between frontend and backend.
In the case that a backend module does not have a corresponding part in the frontend, this is documented appropriately.
The following figure shows the mirrored module structure.

.. mermaid::
    :align: center
    :caption: Schematic overview of the mirrored module structure in VarFish server.

    %%{init: {"flowchart": {"htmlLabels": false}} }%%
    flowchart BT
      varfishServer[VarFish Server]:::other
      frontend[Frontend]:::frontend
      backend[Backend]:::backend
      frontendCaseMgmt[Case Mgmt]:::frontend
      frontendCaseQc[Case QC]:::frontend
      frontendEtc[...]:::frontend
      backendCaseMgmt[Case Mgmt]:::backend
      backendCaseQc[Case QC]:::backend
      backendEtc[...]:::backend

      frontend --> varfishServer
      frontendCaseMgmt --> frontend
      frontendCaseQc --> frontend
      frontendEtc --> frontend

      backend --> varfishServer
      backendCaseMgmt --> backend
      backendCaseQc --> backend
      backendEtc --> backend

      classDef other fill:white
      classDef frontend fill:#c5effc
      classDef backend fill:#e9c5fc

In this document, we will describe the corresponding frontend and backend together, and show simplified figures such as the following.

.. mermaid::
    :align: center
    :caption: Simplified module structure.

    %%{init: {"flowchart": {"htmlLabels": false}} }%%
    flowchart BT
      varfishServer[VarFish Server]
      caseMgmt[Case Mgmt]
      caseQc[Case QC]
      etc[...]

      caseMgmt --> varfishServer
      caseQc --> varfishServer
      etc --> varfishServer
