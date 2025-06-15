
This repository contrains the data and code for *Perceptual-semantic features of words differentially shape early vocabulary in ASL and English*. This README was last updated 6/15/2025. Contact: Erin Campbell (eecamp@bu.edu) or Arielle Borovsky (aborovsky@purdue.edu).

# Contents

## ASL_Feats.Rproj

We recommend starting by opening this .Rproj file. This will set your working directory to the ASL_Feats folder.

## 1.DataPrep_ASL_AoA_Feats_Clean20250606.Rmd

This script reads in the semantic features data, the ASL LEX sign lexical proporties data, and the English CDI vocabulary data, and outputs the file ASLLexFeats.Rdata. Folks can run through the data wrangling steps in this file, or use ASLLexFeats.Rdata to skip right to the analysis script

## 2.ASLLexFeats_Stats.Rmd

## 3.FeaturePlots.R

## data/

This folder contains the following data files:

- ASLLexFeats.Rdata
- CDIwords_featurecounts.csv
- CDIwords_featurelevel.csv
- concs.csv
- English_iconicity_ratings_cleaned.csv: this data came from Bodo Winter's 2024 English iconicity ratings study. It was downloaded from OSF (https://osf.io/ex37k).
- MBCDI_CHILDESv0.1.0_freq.csv
- signdata_20231106_updated.csv
- signdata.csv
- WS_production_aoa_data.csv


## figures/

Contains figures:
- ASLFeats_Frog.png: this was made by Erin Campbell on Canva
- feature_plot.png: this figure illustrates the distribution of perceptual-semantic features is generated in FeaturePlots.R
- three_interactions.jpeg: this figure was made in FeaturePlots.R and illustrates the main results of the paper (interactions between language and perceptual feature type on AoA)

