# Tailoring Rule-Based Data Quality Assessment to the Patient-Centered Outcomes Research Network (PCORnet) Common Data Model (CDM) 
---
## Background
Researchers are encouraged by the high capabilities of electronic health records (EHR) in capturing different types of data that can be used to conduct clinical research. However, data quality issues that may arise especially when combining multiple clinical sources of data need to be addressed before their use, and networks need to be transparent to report them. We will use a rule-based approach to run a quality check against the PCORnet CDM. The rules we used to conduct this study were designed and written by researchers at the University of Texas Health Science Center at San Antonio. These rules are composed of rule logic templates supported by knowledge tables to assist in their implementation.

Copyright (c) 2022 Univeristy of Missouri 

Share information according to the terms of the Apache 2.0 Open Source License.

## AIMS of the project 
**AIM1**: Translate the rules to be compatible to run against PCORnet CDM. We will rewrite the rules according to the CDM table format using SQL language and run them against Missouri Health System data in PCORnet CDM and report the percentage of discrepancies.

**AIM2**:  Scale the analysis and run these rules against the Greater Plains Collaborative Reusable Observable Unified Study Environment (GROUSE). After performing linkage of the PCORnet CDM  with Center of Medical Services (CMS) data, we will run the rules and report the percentage of discrepancies.

## Previous work
1) Kahn MG, Raebel MA, Glanz JM, Riedlinger K, Steiner JF. A pragmatic framework for single-site and multisite data quality assessment in electronic health record-based clinical research. Med Care. 2012 Jul;50 Suppl(0):S21-9. doi: 10.1097/MLR.0b013e318257dd67. PMID: 22692254; PMCID: PMC3833692.
<https://pubmed.ncbi.nlm.nih.gov/22692254/>

2) Wang Z, Talburt JR, Wu N, Dagtas S, Zozus MN. A Rule-Based Data Quality Assessment System for Electronic Health Record Data. Appl Clin Inform. 2020 Aug;11(4):622-634. doi: 10.1055/s-0040-1715567. Epub 2020 Sep 23. PMID: 32968999; PMCID: PMC7511263.<https://pubmed.ncbi.nlm.nih.gov/32968999/>

3) Wang Z, Dagtas S, Talburt J, Baghal A, Zozus M. Rule-Based Data Quality Assessment and Monitoring System in Healthcare Facilities. Stud Health Technol Inform. 2019;257:460-467. PMID: 30741240; PMCID: PMC6692115.
<https://pubmed.ncbi.nlm.nih.gov/30741240/>
