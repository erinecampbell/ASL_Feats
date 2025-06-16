
This repository contrains the data and code for *Perceptual-semantic features of words differentially shape early vocabulary in ASL and English*. This README was last updated 6/15/2025. Contact: Erin Campbell (eecamp@bu.edu) or Arielle Borovsky (aborovsky@purdue.edu).

# Contents

## ASL_Feats.Rproj

We recommend starting by opening this .Rproj file. This will set your working directory to the ASL_Feats folder.

## 1.DataPrep_ASL_AoA_Feats_Clean20250606.Rmd

This script reads in the semantic features data, the ASL LEX sign lexical proporties data, and the English CDI vocabulary data, and outputs the file ASLLexFeats.Rdata. Folks can run through the data wrangling steps in this file, or use ASLLexFeats.Rdata to skip right to the analysis script

## 2.ASLLexFeats_Stats.Rmd

This script reads in data/ASLLexFeats.Rdata (same as concs.csv) and runs the models in the paper. This also generates the interaction plots (figures/three_interactions.jpeg).

## 3.FeaturePlots.R

This script reads in data/ASLLexFeats.Rdata and figures/ASLFeats_Frog.png and creates the polar plot and bar plots for the feature plot graph. 

## data/

This folder contains the following data files:

- ASLLexFeats.Rdata: this data is generated in 1.DataPrep_ASL_AoA_Feats_Clean20250606.Rmd. The file contains word-level data for the CDI words with # of perceptual features, frequency info, and AoA. It has the same content as concs.csv.
- CDIwords_featurecounts.csv: This contains word-level counts of the semantic features by type. It gets read into 1.DataPrep_ASL_AoA_Feats_Clean20250606.Rmd where we add AoA info and the other lexical properties.
- CDIwords_featurelevel.csv: This file contains *feature*-level data for the CDI words.
- concs.csv: this data is generated in 1.DataPrep_ASL_AoA_Feats_Clean20250606.Rmd. It has the same content as ASLLexFeats.Rdata.
- English_iconicity_ratings_cleaned.csv: this data came from Bodo Winter's 2024 English iconicity ratings study. It was downloaded from OSF (https://osf.io/ex37k).
- MBCDI_CHILDESv0.1.0_freq.csv: This file contains CHILDES frequency counts for the CDI words.
- signdata_20231106_updated.csv: EC TO DO: check how/why this file is different from signdata.csv
- signdata.csv: This file was downloaded from ASL LEX 2.0 (https://asl-lex.org/download.html)
- WS_production_aoa_data.csv: This file contains AoA from Wordbank's American English dataset. 


## figures/

Contains figures:
- ASLFeats_Frog.png: this was made by Erin Campbell on Canva
- feature_plot.png: this figure illustrates the distribution of perceptual-semantic features is generated in FeaturePlots.R
- three_interactions.jpeg: this figure was made in FeaturePlots.R and illustrates the main results of the paper (interactions between language and perceptual feature type on AoA)

