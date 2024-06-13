.. _dev_notes:

=================
Development Notes
=================


.. _dev_notes_sodar_core:

-----------------------
Working With Sodar Core
-----------------------

VarFish is based on the Sodar Core framework which has a `developer manual <https://sodar-core.readthedocs.io/en/latest/development.html>`_ itself.
It is worth reading its development instructions.
The following lists the most important topics:

- `Models <https://sodar-core.readthedocs.io/en/latest/dev_project_app.html#models>`_
- `Rules <https://sodar-core.readthedocs.io/en/latest/dev_project_app.html#rules-file>`_
- `Views <https://sodar-core.readthedocs.io/en/latest/dev_project_app.html#views>`_
- `Templates <https://sodar-core.readthedocs.io/en/latest/dev_project_app.html#templates>`_
    - `Icons <https://sodar-core.readthedocs.io/en/latest/dev_general.html#using-icons>`_
- `Forms <https://sodar-core.readthedocs.io/en/latest/dev_project_app.html#forms>`_


.. _dev_notes_tests:

-------------
Running Tests
-------------

Running the VarFish test suite is easy, but can take a long time to finish (>10 minutes).

.. code-block:: bash

    cd backend
    make test
    ## OR
    cd frontend
    make test
    ## or from root
    make test

You can exclude time-consuming UI tests in the backend:

.. code-block:: bash

    cd backend
    make test-noselenium

If you are working on one only a few tests, it is better to run them directly.
To specify them, follow the path to the test file, add the class name and the test function, all separated by a dot:

.. code-block:: bash

    cd backend
    pipenv run python manage.py test -v2 --settings=config.settings.test \
      variants.tests.test_ui.TestVariantsCaseFilterView.test_variant_filter_case_multi_bookmark_one_variant

This would run the UI tests in the variants app for the case filter view.

To speedup your tests, you can use the ``--keepdb`` parameter.
This will only run the migrations on the first test run.


.. _dev_notes_style_linting:

---------------
Style & Linting
---------------

We use `black <https://github.com/psf/black>`__ for formatting Python code, `flake8 <https://flake8.pycqa.org/en/latest/>`__ for linting, and `isort <https://pycqa.github.io/isort/>`__ for sorting includes.
To ensure that your Python code follows all restrictions and passes CI, use

.. code-block:: bash

    cd backend
    ## run lint
    make lint
    ## run formatting
    make format

We use `prettier <https://prettier.io/>`__ for Javascript formatting and `eslint <https://eslint.org/>`__ for linting the code.
Similarly, you can use the following for the Javascript/Vue code:

.. code-block:: bash

    cd frontend
    ## run lint
    make lint
    ## run formatting
    make format

Or, all together (from checkout root)

.. code-block:: bash

    ## run lint
    make lint
    ## run formatting
    make format


.. _dev_storybook:

---------
Storybook
---------

We use `Storybook.js <https://storybook.js.org/docs/vue/get-started/introduction>`__ to develop Vue components in isolation.
You can launch the Storybook server by calling:

.. code-block:: bash

    cd frontend
    ## ensure dependencies are the
    make deps
    ## run server
    make storybook


.. _dev_git:

----------------
Working With Git
----------------

In this section we will briefly describe the workflow how to contribute to VarFish.
This is not a git tutorial and we expect basic knowledge.
We recommend `gitready <https://gitready.com/>`_ for any questions regarding git.
We do use `git rebase <https://gitready.com/intermediate/2009/01/31/intro-to-rebase.html>`_ a lot.

In general, we recommend to work with ``git gui`` and ``gitk``.

The first thing for you to do is to create a fork of our github repository in your github space.
To do so, go to the `VarFish repository <https://github.com/varfish-org/varfish-server>`_ and click on the ``Fork`` button in the top right.

.. _dev_git_main:

Update Main
===========

Als refer to `Pull with rebase on gitready <https://gitready.com/advanced/2009/02/11/pull-with-rebase.html>`__

.. code-block:: bash

    git pull --rebase

.. _dev_git_working_branch:

Create Working Branch
=====================

Always create your working branch from the latest main branch.
Use the ticket number and description as name, following the format ``<ticket_number>-<ticket_title>``, e.g.

.. code-block:: bash

    git checkout -b 123-adding-useful-feature


.. _dev_git_commit_msg:

Write A Sensible Commit Message
===============================

A commit message should only have 72 characters per line.
As the first line is the representative, it should sum up everything the commit does.
Leave a blank line and add three lines of github directives to reference the issue.

.. code-block::

    Fixed serious bug that prevented user from doing x.

    Closes: #123
    Related-Issue: #123
    Projected-Results-Impact: none


.. _dev_git_single_commit_pr:

Single Commit in PR
===================

Our GitHub repositories are configured to enforce squash commits.
That is, all commits in a PR will be squashed into one.


.. _dev_git_semantic_prs:

Semantic Pull Requests
======================

We use semantic pull requests / `ConventionalCommits.org <https://www.conventionalcommits.org/en/v1.0.0/>`__, enforced by this `GitHub Action <https://github.com/marketplace/actions/semantic-pull-request>`__.

Use one of the following prefixes to get an entry in the README:

- ``fix:`` - bug fix, bump patch version
- ``feat:`` - feature, bump minor version

The following do not create entries in the README:

- ``ci:`` - continuous integration change
- ``docs:`` - documentation
- ``chore:`` - misc chore

To force the latter to create an entry in the README, add ``Release-As: THE.NEXT.VERSION`` in the squash commit message.
