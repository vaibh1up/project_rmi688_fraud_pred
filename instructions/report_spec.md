# LaTeX Report Specification

## 0. Report expectation
The report should be a self-contained professional report of high quality that can be presented to the management of a company for action

## 1. Document Structure
The agent must generate the following modular files in `/draft`:
- `introduction.tex`:Include a professional problem statement regarding the dual challenge of minimizing financial leakage (Fraud) while maintaining a frictionless customer experience. Do not just list the report structure; provide a high-level executive summary of the findings.
 
- `data_methods.tex`: data subsection: Discuss the data through a 'risk economics' lens. discuss and justify any data cleaning steps briefly. show Summary Stats table, and discuss key stats of dependent var; show and discuss cost-benefit matrix, here explain the asymmetric risk (e.g., why a False Negative is $10 \times$ more damaging than a False Positive). method subsection: discuss approach of using three models; explain models along with their pros and cons; explain why they are appropriate for this specific nature of insurance fraud risk.; explain the rational how we will choose the best.

- `results.tex`: "Move beyond reporting the numbers. For each model, discuss its 'behavior.' For example, explain why the Random Forest’s higher sensitivity is critical for this specific payoff structure."; 
discuss each model in detail; Comparison of the 3 models (Specs + Performance tables); 
- `recommend.tex`: Discuss the trade-off between **Sensitivity** (catching fraud) and **Specificity** (avoiding false alarms); Pros/Cons analysis and final selection logic; discuss which model is best and why; discuss how changes in cost-benefit might change choice; Justify the choice based on the **Total Business payoff** formula from `data_spec.md`.
- `main.tex`: The wrapper file using `\documentclass{article}`. 

## 2.Tone & Style:
- Use a professional, third-person analytical tone (e.g., "The results suggest..." instead of "I found...").
- Avoid bullet points for narrative sections; use full, well-structured paragraphs.
- Synthesis Requirement: Every table must be accompanied by at least two paragraphs of analytical commentary that explains what the data implies for the business.

## 3. Preamble Requirements
The `main.tex` must include:
- `\usepackage{booktabs}` (for professional tables)
- `\usepackage{graphicx}` (for plots from /output/plots)
- `\usepackage{geometry}` (set margins to 1 inch)
- `\usepackage{caption}` (for table/figure numbering)

## 4. Table Formatting
- **Environment:** Use `table` and `tabular` environments.
- **Rules:** Use `\toprule`, `\midrule`, and `\bottomrule`. No vertical lines.
- **Labels:** Every table must have a unique `\label{tab:name}`.
 