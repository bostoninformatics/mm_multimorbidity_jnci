# Code for "Defining multimorbidity and its impact in older united states veterans newly treated for multiple myeloma"

## Overview

This repository contains code to define patterns of multimorbidity via latent class analysis as described in the following paper:

> Fillmore N, DuMontier C, Yildirim C, La J, Epstein MM, Cheng D, Cirstea D, Yellapragada S, Abel GA, Gaziano JM, Do N, Brophy M, Kim DH, Munshi NC, Driver JA. Defining multimorbidity and its impact in older united states veterans newly treated for multiple myeloma. J Natl Cancer Inst. 2021 Feb 1:djab007. doi: 10.1093/jnci/djab007. Epub ahead of print. PMID: 33523236.

For further information or assistance with this code, please reach out to the authors, especially [Nathanael Fillmore](https://scholar.harvard.edu/nfillmore) or [Clark DuMontier](https://connects.catalyst.harvard.edu/Profiles/display/Person/161791).

## Instructions

* Use CMS Chronic Conditions Warehouse algorithms (https://www.ccwdata.org/web/guest/condition-categories) to define chronic conditions.
* Use `tweak_ccw.R` to combine similar chronic conditions.
* Use `run_lca_grid_search.R` to run latent class analysis to define multimorbidity patterns.
* Conduct downstream analysis such as construction of Kaplan-Meier curves as appropriate.
