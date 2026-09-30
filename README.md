# Beyond the Subword Bottleneck: Quantifying Multilingual Tokenization Disparities in Cross-Lingual Language Models

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10892471.svg)](https://doi.org/10.5281/zenodo.10892471)
[![Python 3.10](https://img.shields.io/badge/Python-3.10-blue.svg)](https://www.python.org/)
[![Reproducibility Status](https://img.shields.io/badge/Reproducibility-100%25%20Audited-brightgreen.svg)]()

This repository contains the authoritative reproducible artifact package, item-level and aggregate statistical datasets, configuration environments, and high-resolution figures for the paper:  
**"Beyond the Subword Bottleneck: A Diagnostic Tri-Metric Evaluation of Cross-Lingual Tokenization Inefficiencies in Low-Resource and Typologically Diverse Languages"**.

---

## 📑 Table of Contents
1. [Overview & Graphical Abstract](#overview--graphical-abstract)
2. [Diagnostic Figures Gallery (High-Resolution JPEG 300 DPI)](#diagnostic-figures-gallery)
3. [Empirical Summary & Statistical Tables](#empirical-summary--statistical-tables)
4. [Key Research Conclusions](#key-research-conclusions)
5. [Repository Structure](#repository-structure)
6. [Reproducibility & Execution Guide](#reproducibility--execution-guide)
7. [Citation](#citation)
8. [License & Inquiries](#license--inquiries)

---

## 🔬 Overview & Graphical Abstract

Subword tokenizers (e.g., BPE, WordPiece, Unigram) introduce structural, downstream, and computational disparities across typologically diverse languages. This project presents a tri-metric diagnostic framework comprising:
- **TCR (Tokenization Cost Ratio):** Sequence expansion relative to raw character/word length.
- **TMR (Token-Morpheme Ratio):** Alignment between subword segments and semantic/morphological boundaries.
- **TCI (Token Collision Index):** Subword vocabulary reuse and semantic representation integrity.

<div align="center">
  <img src="Beyond_Subword_Bottleneck_Figures_JPEG/graphical_abstract.jpg" alt="Graphical Abstract" width="100%">
  <p><em>Figure 0: Graphical Abstract – Multilingual Tokenization Bottleneck and Diagnostic Metric Workflow.</em></p>
</div>

---

## 🖼️ Diagnostic Figures Gallery

All figures are compiled and audited in uncompressed high-resolution **JPEG (300 DPI)** format.

### Figure 1 & Figure 2: Sequence Cost & Morphological Misalignment
| Figure 1: Mean Tokenization Cost Ratio (TCR) | Figure 2: Mean Token-Morpheme Ratio (TMR) |
| :---: | :---: |
| <img src="Beyond_Subword_Bottleneck_Figures_JPEG/Figure_1_TCR.jpg" alt="Figure 1 TCR" width="100%"> | <img src="Beyond_Subword_Bottleneck_Figures_JPEG/Figure_2_TMR.jpg" alt="Figure 2 TMR" width="100%"> |
| *Mean sequence expansion across English, Russian, Igbo, and Amharic.* | *Morphological fragmentation ratio evaluated against lexical boundaries.* |

### Figure 3 & Figure 4: Collision Index & Diagnostic Quadrant Profile
| Figure 3: Mean Token Collision Index (TCI) | Figure 4: TCR vs. TCI Joint Diagnostic Profile |
| :---: | :---: |
| <img src="Beyond_Subword_Bottleneck_Figures_JPEG/Figure_3_TCI.jpg" alt="Figure 3 TCI" width="100%"> | <img src="Beyond_Subword_Bottleneck_Figures_JPEG/Figure_4_TCR_TCI_Profile.jpg" alt="Figure 4 TCR vs TCI Profile" width="100%"> |
| *Token Collision Index (TCI) indicating vocabulary sharing and fragmentation.* | *Diagnostic quadrant mapping: Optimal, Syntactic Dilution, Semantic Drift.* |

### Figure 5 & Figure 6: Length Sensitivity Curves
| Figure 5: TCR vs. Sequence Length | Figure 6: TMR vs. Text Length |
| :---: | :---: |
| <img src="Beyond_Subword_Bottleneck_Figures_JPEG/Figure_5_TCR_Sequence_Length.jpg" alt="Figure 5 Sequence Length" width="100%"> | <img src="Beyond_Subword_Bottleneck_Figures_JPEG/Figure_6_TMR_Text_Length.jpg" alt="Figure 6 Text Length" width="100%"> |
| *Scaling behavior of TCR across variable sequence token lengths.* | *Stability of Token-Morpheme Ratio across increasing text context lengths.* |

### Figure 7 & Figure 8: Scaling Dynamics & Bivariate Scatter
| Figure 7: TCI vs. Vocabulary Size | Figure 8: Item-Level Bivariate Scatter (TCR vs. TCI) |
| :---: | :---: |
| <img src="Beyond_Subword_Bottleneck_Figures_JPEG/Figure_7_TCI_Vocabulary_Size.jpg" alt="Figure 7 Vocabulary Size" width="100%"> | <img src="Beyond_Subword_Bottleneck_Figures_JPEG/Figure_8_TCR_TCI_Scatter.jpg" alt="Figure 8 Bivariate Scatter" width="100%"> |
| *Impact of vocabulary size allocation on subword collision and dilution.* | *Item-level distribution ($N=300$) depicting cross-lingual separation.* |

### Figure 9: Qualitative Subword Segmentation Exemplars
<div align="center">
  <img src="Beyond_Subword_Bottleneck_Figures_JPEG/Figure_9_Qualitative_Examples.jpg" alt="Figure 9 Qualitative Examples" width="95%">
  <p><em>Figure 9: Representative sentence segmentations and token IDs across Latin, Cyrillic, and Ge'ez scripts.</em></p>
</div>

---

## 📊 Empirical Summary & Statistical Tables

Evaluations are performed on $N=300$ curated sentences across four typologically distinct languages ($n=75$ items per language): **English** (Analytic/Germanic), **Russian** (Fusional/Slavic), **Igbo** (Agglutinative-Isolating/Volta-Niger), and **Amharic** (Root-and-Pattern Semitic/Ge'ez script).

### Table 1: Comprehensive Language Metric Summary ($N=300$)
| Language | Script / Family | Items ($N$) | Mean TCR (± SD) | Mean TMR (± SD) | Mean TCI (± SD) |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **English** | Latin / Germanic | 75 | $0.1735 \pm 0.0566$ | $1.0000 \pm 0.0000$ | $0.9807 \pm 0.0274$ |
| **Russian** | Cyrillic / Slavic | 75 | $0.3994 \pm 0.0606$ | $1.6200 \pm 0.0000$ | $0.6493 \pm 0.0517$ |
| **Igbo** | Latin / Volta-Niger | 75 | $0.6464 \pm 0.0391$ | $1.0000 \pm 0.0000$ | $0.3192 \pm 0.0547$ |
| **Amharic** | Ge'ez / Semitic | 75 | $2.6033 \pm 0.3966$ | $1.0000 \pm 0.0000$ | $0.1948 \pm 0.0479$ |

### Table 2: Omnibus Hypothesis Testing (Kruskal-Wallis $H$-Test)
| Metric | $H$ Statistic | $df$ | $p$-value | Significance | Cliff's Delta Range ($\delta$) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **TCR** | $278.41$ | 3 | $< 0.0001$ | $p < .001^{***}$ | $0.88 - 1.00$ (Extremely Large) |
| **TCI** | $269.18$ | 3 | $< 0.0001$ | $p < .001^{***}$ | $-0.92 - -1.00$ (Extremely Large) |
| **TMR** | $224.00$ | 3 | $< 0.0001$ | $p < .001^{***}$ | Exact Russian split ($\delta = 1.00$) |

*Note: All post-hoc pairwise comparisons (Dunn-Holm adjusted) show statistically significant differences at $\alpha = 0.001$.*

---

## 💡 Key Research Conclusions

1. **The Disproportionate "Token Tax":**
   Low-resource non-Latin scripts (Amharic) incur up to a **15× sequence expansion tax** ($\text{TCR} = 2.6033$) compared to English ($\text{TCR} = 0.1735$). This directly shrinks effective context windows, inflates inference latency, and raises API compute costs.
2. **Morphological Distortion vs. Script Penalty:**
   While Amharic suffers catastrophic byte-level fallback due to vocabulary allocation skew, fusional morphology in Russian causes severe Token-Morpheme fragmentation ($\text{TMR} = 1.62$), degrading semantic preservation.
3. **Severe Semantic Dilution (TCI Degradation):**
   Subword collisions and polysemous fragment reuse collapse the Token Collision Index from **0.9807** (English) to **0.1948** (Amharic) and **0.3192** (Igbo), compromising downstream representation stability.
4. **Call for Script-Fair Tokenization Architectures:**
   Heuristic vocabulary allocation based purely on pretraining corpus volume systematically disadvantages low-resource and non-Latin languages. Universal LMs require character/byte-aware hybrid routing or script-balanced vocabulary allocation to close the cross-lingual performance divide.

---

## 🌲 Repository Structure
```text
beyond-subword-bottleneck/
├── .github/
│   └── workflows/
│       └── reproducibility.yaml             # Automated CI/CD audit & reproduction workflow
├── Beyond_Subword_Bottleneck_Figures_JPEG/ # Canonical 300 DPI high-quality figures
│   ├── graphical_abstract.jpg              # Graphical Abstract
│   ├── Figure_1_TCR.jpg                    # Figure 1: Mean TCR Bar Plot
│   ├── Figure_2_TMR.jpg                    # Figure 2: Mean TMR Bar Plot
│   ├── Figure_3_TCI.jpg                    # Figure 3: Mean TCI Bar Plot
│   ├── Figure_4_TCR_TCI_Profile.jpg        # Figure 4: Joint Quadrant Profile
│   ├── Figure_5_TCR_Sequence_Length.jpg    # Figure 5: TCR vs Text Length
│   ├── Figure_6_TMR_Text_Length.jpg        # Figure 6: TMR vs Text Length
│   ├── Figure_7_TCI_Vocabulary_Size.jpg    # Figure 7: TCI vs Vocabulary Allocation
│   ├── Figure_8_TCR_TCI_Scatter.jpg        # Figure 8: Bivariate Item-Level Scatter
│   └── Figure_9_Qualitative_Examples.jpg   # Figure 9: Subword Tokenization Qualitative Table
├── config/
│   ├── dataset_catalog.yaml                # Dataset schema and variable definitions
│   ├── environment.yaml                    # Conda dependency specification (Python 3.10)
│   └── experiment_config.yaml              # Statistical parameters & visual rendering configs
├── processed_data/                         # Structured tabular data artifacts
│   ├── 01_cleaned_item_level_data.csv      # Cleaned item-level observations (N=300)
│   ├── 02_language_descriptive_summary.csv # Mean, SD, Median, IQR across metrics
│   ├── 03_metric_normality_tests.csv       # Shapiro-Wilk test outcomes
│   ├── 04_homoscedasticity_tests.csv       # Levene's variance homogeneity tests
│   ├── 05_kruskal_wallis_omnibus.csv       # Omnibus non-parametric results
│   ├── 06_pairwise_dunn_holm_tcr.csv       # Post-hoc pairwise Dunn-Holm for TCR
│   ├── 07_pairwise_dunn_holm_tci.csv       # Post-hoc pairwise Dunn-Holm for TCI
│   ├── 08_pairwise_dunn_holm_tmr.csv       # Post-hoc pairwise Dunn-Holm for TMR
│   ├── 16_diagnostic_quadrant_classification.csv # Language quadrant clustering
│   ├── 17_english_subword_parity_index.csv # Normalized parity ratios relative to English
│   ├── 18_bootstrap_confidence_intervals.csv # 95% BCa bootstrap CI estimates
│   ├── 19_data_dictionary_and_codebook.csv # Formal variable definitions
│   └── 20_reproducibility_audit_log.csv    # SHA-256 hash log and pipeline audit
├── reproducibility_package/
│   └── notebooks/                          # 10 Jupyter Notebooks for step-by-step reproduction
├── final_analysis_dataset.csv              # Master consolidated item dataset
├── language_summary_table.csv              # Benchmark aggregate statistics table
├── figures_jpeg_pack.zip                   # Full high-res JPEG image bundle
├── processed_data_20.zip                   # Compressed archive of all 20 processed data tables
├── yaml_configuration_files.zip            # Packed YAML configuration files
├── LICENSE                                 # MIT Open-Source License
└── README.md                               # Project documentation & benchmark overview
