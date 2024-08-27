# Code Club project: Assessing whether intra and inter-genomic variations hinder utility of ASVs.

**Author:** Gaurav Bhatti

Developed over a series of *Code Club* episodes led by Pat Schloss to answer an important question in microbiology and develop comfort using tools to do reproducible research.

##Questions##
* Within a genome, how many distinct copies of the 16S rRNA gene
  relative to the number of copies per genome? How far apart are these
  sequences from each other? How does this scale from a genome to
  kingdoms?
* Within a taxa (any level), how many ASVs from that taxa are shared
    with sister taxa? How does this change with taxonomic level ?
    Variable region?

* Make sure we have taxonomic data for all our genomes
* Read fasta files into R (do it on our own)
* inner_join with tsv file
* group_by/summarize to count the number of sequences and copies per
  genome.

### Dependencies:
* [mothur  Version 1.48.1](https://github.com/mothur/mothur/releases)-`code/get_mothur.sh` downloads/extracts/installs mothur.
* `wget`
* `curl`



