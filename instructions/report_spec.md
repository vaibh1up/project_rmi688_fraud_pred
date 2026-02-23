# LaTeX Report Specification

## 1. Document Structure
The agent must generate the following modular files in `/draft`:
- `introduction.tex`: Context and problem statement.
- `data_methods.tex`: Data cleaning steps and Summary Stats table.
- `results.tex`: Comparison of the 3 models (Specs + Performance tables).
- `recommend.tex`: Pros/Cons analysis and final selection logic.
- `main.tex`: The wrapper file using `\documentclass{article}`.

## 2. Preamble Requirements
The `main.tex` must include:
- `\usepackage{booktabs}` (for professional tables)
- `\usepackage{graphicx}` (for plots from /output/plots)
- `\usepackage{geometry}` (set margins to 1 inch)
- `\usepackage{caption}` (for table/figure numbering)

## 3. Table Formatting
- **Environment:** Use `table` and `tabular` environments.
- **Rules:** Use `\toprule`, `\midrule`, and `\bottomrule`. No vertical lines.
- **Labels:** Every table must have a unique `\label{tab:name}`.

## 4. Model Analysis Logic
For `recommend.tex`, the agent must:
1. Discuss the trade-off between **Sensitivity** (catching fraud) and **Specificity** (avoiding false alarms).
2. Justify the choice based on the **Total Business Cost** formula from `data_spec.md`.