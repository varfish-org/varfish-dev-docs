# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

import os
import subprocess

# determine version from git
git_version_bytes = subprocess.check_output(
    ["git", "describe", "--tags", "--long"],
    cwd=os.path.dirname(os.path.abspath(__file__)),
)
git_version = git_version_bytes.decode("utf-8").strip()[1:]

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = "VarFish DevDocs"
copyright = "2024, VarFish Team"
author = "Manuel Holtgrewe"
version = git_version
release = git_version

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = ["sphinxcontrib.mermaid"]

templates_path = ["_templates"]
exclude_patterns = []

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_title = "VarFish Dev Docs"
html_theme = "furo"
html_static_path = ["_static"]
html_theme_options = {
    "sidebar_hide_name": False,
}

# -- Options for mermaid rendering -------------------------------------------

mermaid_output_format = "raw"
mermaid_params = ["-p" "puppeteer-config.json"]
