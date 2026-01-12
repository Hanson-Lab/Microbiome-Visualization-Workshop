#!/usr/bin/env Rscript
############################################################
# 00_install_packages.R
#
# Microbiome Visualization Workshop
# Install + load required R packages (CRAN + Bioconductor)
#
# How to run:
#   source("scripts/00_install_packages.R")
#   # or from terminal:
#   Rscript scripts/00_install_packages.R
#
# Notes for Posit Cloud:
# - This script is safe to run multiple times.
# - It installs only missing packages by default.
############################################################

message("=== Microbiome Visualization Workshop: Package setup ===")

# Helper function: install missing CRAN packages
install_cran_if_missing <- function(pkgs) {
  for (p in pkgs) {
    if (!requireNamespace(p, quietly = TRUE)) {
      message("Installing CRAN package: ", p)
      install.packages(p, repos = "https://cloud.r-project.org")
    } else {
      message("CRAN package already installed: ", p)
    }
  }
}

# Helper function: install missing Bioconductor packages
install_bioconductor_if_missing <- function(pkgs) {
  if (!requireNamespace("BiocManager", quietly = TRUE)) {
    message("Installing CRAN package: BiocManager")
    install.packages("BiocManager", repos = "https://cloud.r-project.org")
  }

  for (p in pkgs) {
    if (!requireNamespace(p, quietly = TRUE)) {
      message("Installing Bioconductor package: ", p)
      BiocManager::install(p, update = FALSE, ask = FALSE)
    } else {
      message("Bioconductor package already installed: ", p)
    }
  }
}

# ---------------------------
# Define required packages
# ---------------------------

# Workshop packages hosted in CRAN
cran_pkgs <- c(
  "ggplot2",
  "dplyr",
  "tidyr",
  "tibble",
  "stringr",
  "readr",
  "pheatmap",
  "knitr", 
  "tidyverse",
  "igraph"
)

# Workshop packages hosted in Bioconductor
bioconductor_pkgs <- c(
  "phyloseq",
  "vegan",
  "microbiome",
  "microViz",
  "ALDEx2"
)

# Optional / nice-to-have CRAN packages used for some workshop enhancements
optional_cran_pkgs <- c(
  "patchwork",   # side-by-side plots
  "cowplot",     # plot alignment
  "scales"       # nicer scales/log formatting
)

# ---------------------------
# Install packages
# ---------------------------

install_cran_if_missing(cran_pkgs)
install_cran_if_missing(optional_cran_pkgs)
install_bioconductor_if_missing(bioconductor_pkgs)

# ---------------------------
# Load packages silently but allow errors
# ---------------------------

required_pkgs <- c(cran_pkgs, bioconductor_pkgs)

message("\n=== Loading required packages ===")
for (p in required_pkgs) {
  suppressPackageStartupMessages(library(p, character.only = TRUE))
  message("Loaded: ", p)
}

message("\nPackage setup complete.")
message("Tip: If you see compilation errors on some systems, try restarting R and re-running this script.")
