.. _des_case_files:

==================
Design: Case Files
==================

This document describes the software design of the **Case Files** module.
This module has the following responsibilities:

#. Maintain the database records for
    - storing references/paths of files related to cases's invidiuals in the internal file storage (e.g., sequence alignment files)
    - the same for files related to the whole case (e.g., variant call files)
#. Provide the CRUD operations on these records
