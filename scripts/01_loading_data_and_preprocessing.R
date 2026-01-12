#!/usr/bin/env Rscript
############################################################
# 01_loading_data_and_preprocessing.R
#
# Microbiome Visualization Workshop
# Load and preprocess microbiome data, then build a phyloseq object.
#
# What this script does:
#   1) Confirms you are running from the project root (relative paths)
#   2) Loads OTU table, taxonomy table, and sample metadata from /data
#   3) Checks that sample IDs and taxon IDs align across files
#   4) Constructs a phyloseq object for downstream analysis
#
# How to run:
#   - In RStudio / Posit Cloud:
#       source("scripts/01_loading_data_and_preprocessing.R")
#   - From terminal:
#       Rscript scripts/01_loading_data_and_preprocessing.R
#
# Notes:
#   - This script assumes the repository structure:
#       data/otu_table.csv
#       data/taxonomy_table.csv
#       data/metadata_table.csv
#   - Required packages are installed and loaded via:
#       scripts/00_install_packages.R
############################################################

message("=== Microbiome Visualization Workshop: Load + preprocess data ===")

### Setting the paths to our workshop data
# Sanity check to ensure you are at the project root (important for appropriate data downloading)
if (!dir.exists("data")) {
  stop(
    "The 'data/' directory was not found.\n",
    "Make sure you opened the project (not just the script)."
  )
} else {
  message("Data directory found")
}

# Define data directory to reflect the relative pathing of our project repository.
# This is the name of the folder in github with all of the data in it.
data_dir <- "data"

# File paths (relative to project root)
otu_path      <- file.path(data_dir, "otu_table.csv")
taxonomy_path <- file.path(data_dir, "taxonomy_table.csv")
metadata_path <- file.path(data_dir, "metadata_table.csv")

# Confirm files exist 
for (f in c(otu_path, taxonomy_path, metadata_path)) {
  if (!file.exists(f)) {
    stop("Missing required file: ", f)
  }
}
message("Data files found")

### Loading the dataset into R
# OTU table - this data is samples as columns and OTUs as rows
otu_df <- read.csv(otu_path, header = TRUE, row.names = 1, 
check.names = FALSE, stringsAsFactors = FALSE)
# Taxonomy table - the taxonomy for each OTU
taxonomy_df <- read.csv(taxonomy_path, header = TRUE, row.names = 1, 
check.names = FALSE, stringsAsFactors = FALSE)
# Metadata table - the metadata by sample
metadata_df <- read.csv(metadata_path, header = TRUE, row.names = 1,
 check.names = FALSE, stringsAsFactors = FALSE)

### Data integrity checks 
# Check dimensions
stopifnot(nrow(otu_df) > 0, ncol(otu_df) > 0)
stopifnot(nrow(taxonomy_df) > 0, ncol(taxonomy_df) > 0)
stopifnot(nrow(metadata_df) > 0, ncol(metadata_df) > 0)

### Data formatting and building the phyloseq object 
## Format each data frame for phyloseq
# Format OTU data frame
phyloseq_otu  <- otu_table(as.matrix(otu_df), taxa_are_rows = TRUE)
# Convert taxonomy table into a matrix and format
taxonomy_matrix <- as.matrix(taxonomy_df)
phyloseq_taxonomy  <- tax_table(taxonomy_matrix)
# Format metadata data frame
phyloseq_metadata <- sample_data(metadata_df)

# Combined the formatted objects into a phyloseq object
phyloseq_object <- phyloseq(phyloseq_otu, phyloseq_taxonomy, phyloseq_metadata)

message("Phyloseq object created")

### Checks to make sure the phyloseq object is formatted correctly
# Summary phyloseq object information 
cat("\n--- Phyloseq object description ---\n")
print(phyloseq_object)
# Print the top 6 lines of the metadata stored in the phyloseq object
cat("\n--- Metadata (first 6 rows) ---\n")
print(head(as.data.frame(sample_data(phyloseq_object))))
# Print the top 6 lines of the taxonomy data stored in the phyloseq object
cat("\n--- Taxonomy table (first 6 taxa) ---\n")
print(head(as.data.frame(tax_table(phyloseq_object))))
#Print the top 6 taxa of the OTU data stored in the phyloseq object
cat("\n--- OTU table (first 6 taxa x first 6 samples) ---\n")
otu_preview <- as(otu_table(phyloseq_object), "matrix")[
  1:min(6, ntaxa(phyloseq_object)),
  1:min(6, nsamples(phyloseq_object)),
  drop = FALSE
]
print(otu_preview)