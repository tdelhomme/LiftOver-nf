# LiftOver-nf

## Nextflow pipeline to convert BED/VCF files between two genomes

![Workflow representation](LiftOver-nf.png)

## Description

Use __picard tool__ to lift over BED or VCF files.  

This scripts takes a set of a folder containing VCF or BED files as an input.

## Dependencies

1. This pipeline is based on [nextflow](https://www.nextflow.io). As we have several nextflow pipelines, we have centralized the common information in the [IARC-nf](https://github.com/IARCbioinfo/IARC-nf) repository. Please read it carefully as it contains essential information for the installation, basic usage and configuration of nextflow and our pipelines.

2. External software:

- [picard tool](http://broadinstitute.github.io/picard/). Note that __picard__ requires Java 1.8 installed.

3. External files:

- The pipeline needs chains files, which contain all the information about translation between two genomes. They can be downloaded from the [UCSC website](hgdownload.cse.ucsc.edu/goldenPath/) selecting the genome you want to translate from.


## Input

|         Name        |              Description              |
|---------------------|---------------------------------------|
| `--input_folder`    | Folder containing BED or VCF files    |
| `--chain_folder`    | Folder containing chain files         |
| `--ref`             | Reference fasta file for the target genome |

If input is a VCF folder, files may have `.vcf` or `.vcf.gz` extension. If input is a BED folder, files may have `.bed` or `.txt` extension.  

## Parameters

  * #### Mandatory

| Name      | Example value | Description     |
|-----------|---------------|-----------------|
| `--genome_from`     | Genome you want to translate __from__ |
| `--genome_into`     | Genome you want to translate __into__ |

Examples of accepted values for `--genome_from` and `--genome_into` parameter:
  * hg38 / hg19 / hg18 / hg17
  * GRCh38 / GRCh37


  * #### Optional

| Name                 | Default value | Description     |
|----------------------|---------------|-----------------|
| `--output_folder`    |  `liftover_output/`    | Folder to output resulting translated files |

  * #### Flags

Flags are special parameters without value.

| Name      | Description     |
|-----------|-----------------|
| `--help`    | Display help |

## Usage

Simple use case example:
```bash
nextflow run iarcbioinfo/LiftOver-nf --input_folder VCF/ --ref ref.fasta
```

## Output
  | Type      | Description              |
  |-----------|--------------------------|
  | BED/VCF   | Translated BED/VCF files |

## Contributions

  | Name      | Email | Description     |
  |-----------|---------------|-----------------|
  | Tiffany Delhomme*    | tiffany.delhomme@irbbarcelona.org | Developer to contact for support |
