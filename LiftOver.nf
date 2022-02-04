#! /usr/bin/env nextflow

//vim: syntax=groovy -*- mode: groovy;-*-

// Copyright (C) 2017 IARC/WHO

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

params.help = null
params.input_folder = null
params.ref = null
params.chain_folder = null
params.output_folder = "liftover_output"
params.genome_from = null
params.genome_into = null
params.picard = "picard"
params.ext = ".bed"

log.info ""
log.info "--------------------------------------------------------"
log.info "  LiftOver-nf : Nextflow pipeline for picard liftover    "
log.info "--------------------------------------------------------"
log.info "Copyright (C) IARC/WHO - IRB Barcelona"
log.info "This program comes with ABSOLUTELY NO WARRANTY; for details see LICENSE"
log.info "This is free software, and you are welcome to redistribute it"
log.info "under certain conditions; see LICENSE for details."
log.info "--------------------------------------------------------"
log.info ""

if (params.help) {
    log.info ''
    log.info '--------------------------------------------------'
    log.info '  USAGE              '
    log.info '--------------------------------------------------'
    log.info ''
    log.info 'Usage: '
    log.info 'nextflow run iarcbioinf/LiftOver-nf --input_folder VCF/ --ref ref.fasta --chain_folder /data/chains'
    log.info ''
    log.info 'Mandatory arguments:'
    log.info '    --input_folder         FOLDER                  Folder containing input files.'
    log.info '    --ref                  FILE (with index)       Reference fasta file (target genome) indexed.'
    log.info '    --chain_folder         FOLDER                  Folder containing chains files.'
    log.info '    --genome_from          STRING                  Name of genome of inputs.'
    log.info '    --genome_into          STRING                  Name of genome of outputs.'
    log.info 'Optional arguments:'
    log.info '    --picard               STRING                  Where is picard? default: picard.'
    log.info '    --ext                  STRING                  Extension of input files, default:.bed.'
    log.info '    --output_folder        FOLDER                  Output folder (default: liftover_output).'
    log.info ''
    exit 1
}

assert (params.ref != true) && (params.ref != null) : "please specify --ref option (--ref reference.fasta(.gz))"
assert (params.genome_from != true) && (params.genome_from != null) : "please specify --genome_from option"
assert (params.genome_into != true) && (params.genome_into != null) : "please specify --genome_into option"

assert (params.input_folder != true) && (params.input_folder != null) : "please specify --input_folder option"

fasta_ref = file(params.ref)
fasta_ref_fai = file( params.ref+'.fai' )
chain_file = file( params.chain_folder + "/" + params.genome_from + 'To' + params.genome_into + '.over.chain.gz' )

try { assert fasta_ref.exists() : "\n WARNING : fasta reference not located in execution directory. Make sure reference index is in the same folder as fasta reference" } catch (AssertionError e) { println e.getMessage() }
if (fasta_ref.exists()) {assert fasta_ref_fai.exists() : "input fasta reference does not seem to have a .fai index (use samtools faidx)"}

try { assert file(params.input_folder).exists() : "\n WARNING : input folder not located in execution directory" } catch (AssertionError e) { println e.getMessage() }

// recovering of input files
f = Channel.fromPath( params.input_folder+'/*'+params.ext )
  .ifEmpty { error "Cannot find any file in: ${params.input_folder}" }

process liftover {

    tag { input_tag }

    publishDir params.output_folder, mode: 'move'

    input:
    file f

    output:
    file("${input_tag}_${params.genome_into}*") into outputs1
    file("${input_tag}*reject*") into outputs2

    shell:
    input_tag =  f.baseName.replace(".gz","").replace(".vcf","").replace(".txt","").replace(".bed","")
    file_type = f.extension
    if(file_type == "gz") file_type = "vcf"
    '''
    echo !{file_type}

    !{params.picard} LiftoverVcf \
	   I=!{f} \
	   O=!{input_tag}_!{params.genome_into}.!{file_type} \
	   C=!{chain_file} \
	   REJECT=!{input_tag}_!{params.genome_into}_reject.!{file_type} \
	   R=!{params.ref} \
	   VERBOSITY=ERROR
    '''
}
