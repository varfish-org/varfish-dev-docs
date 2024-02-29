.. _doc_datasources:

===========
Datasources
===========

This section documents the datasources used as input for the static data available in VarFish.

The download and precomputation is done by the Snakemake workflow in ``varfish-db-downloader``.
This git repository uses continous integration with a reduced dataset (and some small data that is used from the repository directly, such as a list of curated microdeletion/-duplication regions from the literature) for automated testing.
The reduced dataset is downloaded automatically from URLs in a ``download_urls.yml`` file.
Thus, there is full transparency and traceability of the data sources used.
Further, a nightly CI job is run to check whether the URLs are still available (but not if the data has changed).


.. _doc_datasources_repo:

------------------
Data in Repository
------------------

The following datasources are used directly from the repository.


.. list-table::
    :widths: 30 20 30 20
    :class: longtable
    :header-rows: 1

    * - Name
      - License
      - Synopsis
      - Source
    * - ACMG SF List v3.1
      - public domain
      - Supplementary Findings Gene List of ACMG
      - `PMID:35802134 <https://europepmc.org/article/med/35802134>`__
    * - DOMINO
      - N/A
      - Score for assessing the probability for a gene to harbour dominant changes
      - Institute of Molecular and Clinical Ophthalmology Basel; `PMID:28985496 <https://europepmc.org/article/med/28985496>`__
    * - Enrichment Regions
      - N/A
      - Target regions of NGS enrichment kits
      - `UCSC Table Browser <https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=map&hgta_track=exomeProbesets&hgta_table=MGI_Exome_Capture_V5&hgta_doSchema=describe+table+schema>`__
    * - Patho MMS
      - N/A
      - Curated regions for microdeletion and microduplication scores
      - `PMID:36435749 <https://europepmc.org/article/med/36435749>`__
    * - sHet
      - N/A
      - Gene haploinsuffiency score
      - `PMID:31004148 <https://europepmc.org/article/med/31004148>`__


.. _doc_datasources_downloaded_data:

---------------
Downloaded Data
---------------

The following datasources are downloaded from public internet resources.


.. list-table::
    :widths: 30 20 30 20
    :class: longtable
    :header-rows: 1

    * - Name
      - License
      - Synopsis
      - Source
    * - AlphaMissense
      - `CC BY-NC-SA 4.0 <https://github.com/google-deepmind/alphamissense?tab=readme-ov-file#alphamissense-predictions-license>`__
      - AlphaMissense score
      - `AlphaMissense <https://github.com/google-deepmind/alphamissense>`__
    * - CADD Score
      - `free for non-commercial <https://cadd.gs.washington.edu/>`__
      - sequence variant pathogenicity scores
      - `CADD <https://cadd.gs.washington.edu/>`__
    * - ClinGen
      - `CC0 <https://clinicalgenome.org/docs/terms-of-use/>`__
      - clinical gene and genome annotation
      - `ClinGen <https://clinicalgenome.org/>`__
    * - Comparative Toxicogenomics Database
      - `free for non-commercial <https://www.catalystresearch.io/products/ctd>`__
      - database of biological named entities
      - `CTD <https://ctdbase.org/>`__
    * - dbNSFP academic
      - suitable for academic use
      - nonsynonymous variant pathogenicity scores
      - `dbNSFP <https://sites.google.com/site/jpopgen/dbNSFP>`__
    * - dbNSFP commercial
      - suitable for commercial use
      - nonsynonymous variant pathogenicity scores
      - `dbNSFP <https://sites.google.com/site/jpopgen/dbNSFP>`__
    * - dbSNP
      - `no restrictions <https://www.ncbi.nlm.nih.gov/home/about/policies/>`__
      - Structural variants from dbSNP
      - `NCBI dbVar <https://www.ncbi.nlm.nih.gov/snp>`__
    * - dbVar
      - `no restrictions <https://www.ncbi.nlm.nih.gov/home/about/policies/>`__
      - Structural variants from dbVar
      - `NCBI dbVar <https://www.ncbi.nlm.nih.gov/dbvar>`__
    * - Database of Genomic Variants (DGV)
      - no restrictions
      - Structural variants from DGV
      - `The Centre for Applied Genomics <http://dgv.tcag.ca/dgv/app/home>`__
    * - DECIPHER HI
      - N/A
      - DECIPHER haploinsufficiency score
      - `PMID:20976243 <https://europepmc.org/article/MED/20976243>`__
    * - ENSEMBL
      - `no restriction <http://www.ensembl.org/info/about/legal/disclaimer.html>`__
      - ENSEMBL gene/genome annotation and transcripts
      - `ENSEMBL <http://www.ensembl.org/index.html>`__
    * - ExAC CNVs
      - `no restrictions <https://gnomad.broadinstitute.org/policies>`__
      - Copy number variants from ExAC
      - `gnomAD <https://gnomad.broadinstitute.org/>`__
    * - GenomicsEngland PanelApp
      - `non-commercial <https://prod-media-panelapp.genomicsengland.co.uk/media/files/GEL_-_PanelApp_Terms_of_Use_December_2019.pdf>`__
      - Gene panels with disease associations from Genomics England
      - `GenomicsEngland <https://panelapp.genomicsengland.co.uk/>`__
    * - gnomAD exomes and genomes
      - `no restrictions <https://gnomad.broadinstitute.org/policies>`__
      - sequence and structural variants, gene constraint scores
      - `gnomAD <https://gnomad.broadinstitute.org/>`__
    * - GTeX
      - `free <https://www.gtexportal.org/home/license>`__
      - tissue-specific gene expression
      - `GTEx <https://www.gtexportal.org/home/>`__
    * - HelixMtDb
      - N/A
      - mitochondrial genome frequencies
      - `HelixMtDb <https://www.helix.com/mitochondrial-variant-database>`__
    * - HGNC
      - `CC0 <https://www.genenames.org/about/license/>`__
      - gene information
      - `HGNC <https://www.genenames.org/>`__
    * - HPO
      - `free <https://hpo.jax.org/app/license>`__
      - Human Phenotype Ontology
      - `HPO <https://hpo.jax.org/app>`__
    * - Human Disease Ontology (DO)
      - `CC0 <https://obofoundry.org/ontology/doid.html>`__
      - ontology of human diseases
      - `Disease Ontology <https://disease-ontology.org/>`__
    * - MONDO
      - `CC BY 4.0 <http://obofoundry.org/ontology/mondo.html>`__
      - Mondo Disease Ontology
      - `OBO Foundry <http://obofoundry.org/ontology/mondo.html>`__
    * - NCBI ClinVar
      - `no restrictions <https://www.ncbi.nlm.nih.gov/home/about/policies/>`__
      - clinical variant interpretation
      - `NCBI ClinVar <https://www.ncbi.nlm.nih.gov/clinvar>`__
    * - NCBI Gene
      - `no restrictions <https://www.ncbi.nlm.nih.gov/home/about/policies/>`__
      - gene information
      - `NCBI Gene <https://www.ncbi.nlm.nih.gov/gene>`__
    * - NCBI mim2gene
      - `no restrictions <https://www.ncbi.nlm.nih.gov/home/about/policies/>`__
      - gene-disease associations
      - `NCBI MedGen <https://ftp.ncbi.nih.gov/gene/DATA>`__
    * - NCBI RefSeq
      - `no restrictions <https://www.ncbi.nlm.nih.gov/home/about/policies/>`__
      - gene/genome annotation and transcripts
      - `NCBI RefSeq <https://www.ncbi.nlm.nih.gov/refseq>`__
    * - OMIM titles
      - restricted
      - some OMIM disease names are contained in other databases such as HPO
      - misc. other datasources
    * - ORDO
      - `CC BY 4.0 <https://www.ebi.ac.uk/ols4/ontologies/ordo>`__
      - Orphanet Rare Disease Ontology
      - `BioOntology.org <http://www.bioontology.org>`__
    * - Orphadata
      - `CC BY 4.0 <https://www.orphadata.com/legal-notice/>`__
      - Orphanet disease-gene associations
      - `Orphadata <https://www.orphadata.org/>`__
    * - rCNV Score
      - N/A
      - dosage sensitivity score
      - `PMID:35917817 <https://europepmc.org/article/med/35917817>`__
    * - TAD annotation
      - N/A
      - Topologically Associated Domains annotation
      - `YUE Lab <http://3dgenome.fsm.northwestern.edu>`__
    * - 1000G SV map
      - `Fort Lauderdale Agreement <https://www.internationalgenome.org/faq/do-i-need-permission-to-use-igsr-data-in-my-own-scientific-research/>`__
      - structural variants from thousand genomes phase 3
      - `IGSR <https://www.internationalgenome.org/data-portal/data-collection/structural-variation>`__
    * - UCSC assembly-related tracks
      - `no restrictions <https://genome.ucsc.edu/license/>`__
      - assembly-related tracks, genomicSuperDups, rmsk, altSeqLiftOverPsl, fixSeqLiftOverPsl, multiz100way
      - `UCSC Table Browser <https://genome.ucsc.edu/cgi-bin/hgTables>`__
