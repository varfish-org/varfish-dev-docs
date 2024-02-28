.. _doc_futureplans:

============
Future Plans
============

This section contains a description of upcoming high-level changes to the VarFish software.
The sections below have been extrapolated from the current issue list.


.. _doc_futureplans_technical_debt:

--------------
Technical Debt
--------------

There is some technical debt, some notable items.

Automated Tests
    We need more automated tests in various areas throughout the codebase.

Python Type Annotations
    We should modernize the codebase by comprehensive use of Python type annotations.
    Notable, this will require type annotations for sodar-core.

Backing Server Protobuf Migration
    The backing services should expose JSON-serialized protobufs on their APIs.
    This will allow for code generation of API clients.


.. _doc_futureplans_grch38_migration:

----------------
GRCh38 Migration
----------------

We support instances with variants in GRCh37, GRCh38, or both genome build coordinates.
However, there is no good upgrade path implemented yet.
The plan here is to provide semi-automated ways to lift over user annotations from GRCh37 to GRCh38 and merely notify people about the cases where this fails.
Variants will need reprocessing and reimport of the original data as we don't consider lift-over of variants to be reliable in the general case.


.. _doc_futureplans_vuetify_migration:

-----------------
Vuetify Migration
-----------------

We need to finalize the migration to the Vuetify framework in the frontend.
Further, we should have the VarFish-specific part of the site (outside of what is provided by sodar-core) become a true SPA without embedding into the HTML + Bootstrap CSS.


.. _doc_futureplans_custom_query_presets:

--------------------
Custom Query Presets
--------------------

We already have some support for custom query presets.
The seqvar query presets need fixing and extension.
The strucvar query presets is missing large parts of implementation (all of the editing functionality).


.. _doc_futureplans_case_management:

---------------
Case Management
---------------

We can attach states such as "closed as solved" to cases, note, and comments.
However, assigning responsible persons to cases and implementing real "workflows" on the case level, e.g., with approval of supervising physicians, is missing.


.. _doc_clinlvar_uploads:

---------------
ClinVar Uploads
---------------

ClinVar uploads are currently missing.
We have the library to perform this already in place and a working implementation of UI can be found in REEV.
This needs careful planning and integration with :ref:`doc_futureplans_case_management`.


.. _doc_futureplans_useability_improvements:

-----------------------
Useability Improvements
-----------------------

The VarFish user interface is useable.
However, there is the need for various improvements to improve the user experience.

Faster Flagging
    The aim here is to provide users with faster "time to flag as X" for variants.
    This is particularly important for visual artifacts in IGV or variants that do not have a connected phenotype.
    This includes both the decision making and access to setting flags.

Better Details Access
    The aim here is to provide users with the information that they need for assessing a variant faster.
    This includes both gene and variant details.
    Improvements can be done by selecting which information where in a smarter way.
    Further improvements can be of technical nature (fewer clicks, faster load times).

Smart Information Access
    In all relevant places such as query result view, variant details, gene details.
    Again, the aim is to provide users with the information that they need for assessing a variant faster.

Blinded Case Analysis
    The aim here is to provide a blinded four-eyes principle for case analysis.

Other Carriers
    The aim here is to provide a quick way to see other cases of the same/similar variants (same genomic position, same amino acid, same gene).
    Also, a visualization of the variation landscape in the gene in the database vs. ClinVar vs. gnomAD would be useful.

Second Hit
    In the case of recessive disorders, it should be faster to find a second hit.
    The idea is that based on a suspicious pathogenic variant, the second hit can be easily found.
    This could be a strucvar overlapping the same gene or another sevar in the same gene that is harder to interpret.
    E.g., a splicing, deep intronic, and/or UTR variant.

Phased Variants
    Haplotype-based variant callers provide phasing information, at least if one read can cover two variants.
    We currently don't expose this information.


.. _doc_futureplans_integrated_variants:

---------------------------
Integrated Variant Analysis
---------------------------

There currently is a strong separation between seqvar and strucvar analysis.
We should implement several strategies for an integrated analysis, taking the case phenotype into consideration.


.. _doc_futureplans_report_generation:

-----------------
Report Generation
-----------------

There are multiple aspects to report generation.
This could consist of providing detailed pages for variants with a selected criteria (e.g., all flagged/considered variants).
Alternatively, this could consist of automatically filling letter templates with variant information.


.. _doc_futureplans_cohort_filter:

----------------
Cohort Filtering
----------------

A much requested feature is performing queries on a cohort level.
We already had a version working earlier that had problems with performance.
This needs to be re-tackled after the migration to the next-gen dataflows is complete.


.. _doc_futureplans_ng_dataflows:

------------------
Next-Gen Dataflows
------------------

The classic location for variants in VarFish is the postgres database.
This works quite well on fast baremetal NVME disk arrays but makes the database the single bottleneck.
It is thus desirable to reengineer this part and work is already underway on this.

We will rather work with data in object storage via the S3 protocol.
By default, Varfish instances will come with an embedded MinIO server for this purpose but external servers can also be used.
Users upload their case files to a location VarFish can access (e.g., S3, HTTPS, local file system) and VarFish is told the location and possibly the necessary credentials.
For import, users only upload a Phenopackets YAML file with the case manifest.
VarFish then imports the case in a background job.
Only the essential files such as variant data (VCF) and QC files are actually read.
Other files such as BAM files, coverage ``.wig`` files, etc. are registered in the database (this allows proxying to them and redisplaying as also mentioned in :ref:`doc_futureplans_genome_browsers`).

VarFish then runs an ingest step that processes the raw caller VCF files and potentially merges VCF files from the same caller.
The resulting ingested VCF files are then stored in the internal object storage.
Further preprocessing can take place, e.g., prefiltering to certain variants such as near-exonic ones.
QC data is imported into the database and potentially additional QC is computed.
Filtration is also done directly on the VCF files from the internal S3 object storage.

The data import is partially done in the server.
We already have fast Rust-based executables for the variant ingest and query execution.
There are unit tests for these components but no integration or system tests yet.
Further, the integration in the server/frontend has not been started yet.

The best way forward is to keep this "next-gen dataflow" in addition to the classic version.
Cases imported in the new way get a tag "version=2" and the new (and yet to be implemented in some parts) code paths will be used for them while the legacy code paths will remain.



.. _doc_futureplans_acmg_criteria:

----------------
ACMG Criteria UI
----------------

We currently have a working version of Richars et al. 2015 implemented.
We need to bring this to the latest ACMG version, ideally both score- and rule-based with certain rule sets (e.g., ACGS, AMP, etc.).
Further, we are completely lacking this for strucvars.
For the latter, this strongly depends on :ref:`doc_futureplans_acmg_automation` as the rules are highly complex here.


.. _doc_futureplans_acmg_automation:

---------------
ACMG Automation
---------------

We need to implement ACMG implementation.
We have a working implementation (not widely tested) for strucvars that is only missing PVS1 automation.
Seqvars is completely missing.


.. _doc_futureplans_clingen_vcep:

------------
ClinGen VCEP
------------

There is a number of genes for which experts have developed complex rule sets.
It would be very useful to have a "rule engine" (could just be some per-gene Python code maintained and deployed with VarFish server) that supports users in these well-known genes with complex rules.


.. _doc_futureplans_additional_variant_types:

------------------------
Additional Variant Types
------------------------

We currently only support seqvars and strucvars.
The following variant types are commonly called from NGS (short and long-read) data.

Repeat Expansion
    E.g., with ExpansionHunger from short-read data or directly from long-read data.

ROH (Run of Homozygosity) / LOH (Loss of Heterozygosity)
    Useful for computing scores such as autozygosity which provides insights into relationships and is useful for quality control.
    ROH data is also often used for the identification of candidate regions.
    It will be easy to implement a graphical tool for homozygosity mapping.

SMA (Spinal Muscular Atrophy) Calling
    There are specialized callers to call SMA mutations from NGS data which is challenging and included in DRAGEN output.
    However, it is questionable how useful this is in a clinical setting as there are cheaper standard tests.

CYP2D6 Caller
    Similar to SMA calling, there are callers and one is included in DRAGEN output.
    However, questionable how important this is.

HLA Calling
    HLA calling can be important in certain aspects and by now there are decent callers for NGS available.
    Again, it is questionable how much demand there is for it.

Methylation Calling
    ONT sequencing provides methylation information.
    Such information could also come from a matched methylation array.


.. _doc_futureplans_long_reads:

----------
Long Reads
----------

We currently have "long read support" already as we can import variants from such data.
However, we will need to adjust rule sets and extend the builtin presets.
As outlined in :ref:`doc_futureplans_additional_variant_types`, it also gives support to methylation information.


.. _doc_futureplans_rnaseq:

-------
RNA-Seq
-------

The integration of DNA variant data and RNA-seq expression data can be useful.
However, there are not many proven cases for *ab initio* RNA-seq for gene prioritization.
Maybe this is primarily useful for integrated analysis where RNA-seq is used for follow-up.


.. _doc_futureplans_genome_browsers:

---------------
Genome Browsers
---------------

After implementing :ref:`doc_futureplans_ng_dataflows`, we also have information about the BAM files in external locations linked to from VarFish.
We can then proxy HTTP requests to them via VarFish and generate IGV sessions or display them in integrated genome browsers such as IGV.js or alternatives.


.. _doc_futureplans_local_pubtator:

--------------
Local PubTator
--------------

PubTator is very useful for semantic search of literature connected to a gene.
The public API has a rate limit.
It is open source and all data is available in monthly dumps.
It might make sense to create a local mirror but this would increase the gap between publication and availability in VarFish to up to a month.
An alternative would be to roll our own engine based on a full text search engine such as QuickWit and open source named entity recognition libraries and ingest the sub-daily releases of PubMed abstracts.


.. _doc_futureplans_facial_gestalt:

--------------------------
Facial Gestalt Integration
--------------------------

Facial gestalt matching is a useful technique for variant priorization.
There is a prototype integration with GestaltMatcher from Bonn.
This integration needs work for a production-ready state but this can also lead into starting out with plugin extension points for VarFish for the deep integration of further external tools.


.. _doc_futureplans_somatic_variant_analysis:

------------------------
Somatic Variant Analysis
------------------------

Alternative tools such as cBioPortal are well-suitable for the analysis of cancer variant data, in particular in a cohort fashion.
However, in certain cases, the analysis of cancer cases with VarFish could be useful.


.. _doc_futureplans_beacon_networks:

---------------
Beacon Networks
---------------

There is some implementation of connecting two VarFish instances via the Beacon API.
This could be explored further or removed.


.. _doc_futureplans_reev_community:

--------------
REEV Community
--------------

We have implemented a public single-variant interpretation tool called REEV.
VarFish instances could be connected together by registering variant annotations and comments there and thus sharing knowledge and connecting to other users.
More features could be implemented to create "groups" in REEV, such that consortia could use it as a connecting component for their local VarFish instances.


.. _doc_futureplans_pipeline_integrations:

---------------------
Pipeline Integrations
---------------------

We could implement a feature that allows for integrating data processing pipelines with VarFish.
Users could register meta data together with their FASTQ files or even flow cell raw data.
The pipelines could then be started running mapping, variant calling, and QC etc.
The results could then be imported into VarFish.
VarFish would orchestrate the pipeline runs through existing external software.

Potential existing pipelines include DRAGEN, ParaBricks, or custom Nextflow / Snakemake pipelines.


.. _doc_futureplans_plugin_extension_points:

-----------------------
Plugin Extension Points
-----------------------

VarFish could serve as a platform for the integration of external tools.
Working examples are the Exomiser for variant prioritization and an emerging one is the GestaltMatcher integration in :ref:`doc_futureplans_facial_gestalt`.
Allowing further integration with other prediction tools or LIMS systems (Gepardo?) could offer the vendors of such tools to integrate well with VarFish.


.. _doc_futureplans_comprehensive_apis:

-------------------
Comprehensive APIs
-------------------

Current API support focuses on what the frontend needs and we don't have comprehensive APIs yet.
Having such APIs would be very useful though, and enable using VarFish as a backend for other tools and platforms.


.. _doc_futureplans_scriptable:

------------------
Scriptable VarFish
------------------

In the inverse of :ref:`doc_futureplans_comprehensive_apis`, we could offer scripting of the query engine.
This would allow advanced users to implement comprehensive analysis directly in VarFish.
