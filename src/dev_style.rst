.. _dev_style:

================
Style Guidelines
================

This documentation contains a short summary of the coding style guidelines used in VarFish.


.. _dev_style_rst:

----------------
RestructuredText
----------------

- follow the current state
- put two new lines before each heading
- put each sentence on its own line (it is a semantic unit and should appear as such in revision control)
- add labels to each section consisting of ``_${file_name}_${section_short}``
- use double-underscore links to prevent collisions


.. _dev_style_py:

------
Python
------

- see linting configuration in ``varfish-server/backend``
- black code style, line length 100
- use isort
- use flake8


.. _dev_style_ts:

----------
TypeScript
----------

- see ESlint configuration in ``varfish-server/frontend``

.. _dev_style_rs:

----
Rust
----

- see `The Rust Style Guide <https://doc.rust-lang.org/nightly/style-guide/>`__
- adhere to all stable clippy hints
