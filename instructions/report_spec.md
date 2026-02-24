# LaTeX Report Specification

## 0. Report Expectation
The objective is to produce a self-contained, professional analytical report of high quality suitable for senior management. The report must prioritize narrative synthesis over raw data output, framing all findings within the context of risk economics and business value optimization.

## 1. Document Structure
The agent must generate the following modular files in `/draft`:
- **`titlepage.tex`**: title page should have report title, author name, date, and abstract (or executive summary of at least 150 words)
- **`introduction.tex`**: 
    - Provide a professional problem statement regarding the dual challenge of minimizing financial leakage from fraud while maintaining a frictionless customer experience. 
    - Include a high-level executive summary of findings rather than a simple table of contents.

- **`data_methods.tex`**: 
    - **Data Subsection**: Discuss the dataset through a "risk economics" lens. Justify cleaning steps (e.g., factor conversion, handling missing values) based on their impact on model robustness.
    - **Economic Framework**: Explicitly define the optimization formula in LaTeX: 
      $$Total\ Business\ Payoff = 10(TP) + 100(TN) - 50(FP) - 500(FN)$$
    - Explain the asymmetric risk where a False Negative is significantly more damaging ($10 \times$) than a False Positive.
    - **Method Subsection**: Discuss the three models (Logistic Regression, Decision Tree, Random Forest); detail their pros/cons and explain why they are appropriate for the specific nature of imbalanced insurance fraud risk.

- **`results.tex`**: 
    - **Narrative Depth**: Discuss each model’s "behavior." Explain the "Payoff Frontier"—how the total payoff fluctuates as thresholds move from conservative to aggressive.
    - **Visual Integration**: Explicitly reference and interpret at least one figure (e.g., Payoff-Threshold curve or ROC curve) from `/output/plots` using "As seen in Figure X...".
    - Provide a comparison of the three models using performance tables and specifications.

- **`recommend.tex`**: 
    - Analyze the trade-off between **Sensitivity** (catching fraud) and **Specificity** (avoiding false alarms).
    - **"What-If" Sensitivity Analysis**: Discuss how the selection would change if the cost-benefit parameters shifted (e.g., if the penalty for False Negatives increased by 20%).
    - Justify the final model selection based on the Maximum Total Business Payoff and expand on the long-term business implications of this optimization.

- **`main.tex`**: The wrapper file using `\documentclass{article}`.

## 2. Tone & Style
- **Voice**: Use a professional, third-person analytical tone (e.g., "The results suggest..." or "Evidence indicates...").
- **Format**: Avoid bullet points in narrative sections; use full, well-structured paragraphs to build an argument. number each section and subsection; all tables and figures round to 2 decimal places
- **spacing and margins**: 1 inch margins; 1.5 space between lines
- **Synthesis Requirement**: Every table and figure must be accompanied by at least two paragraphs of analytical commentary explaining what the data implies for the company's bottom line.

## 3. Preamble & Formatting
- **Packages**: `booktabs` (tables), `graphicx` (figures), `geometry` (1-inch margins), and `caption` (numbering).
- **Table Standards**: Use `table` and `tabular` environments with `\toprule`, `\midrule`, and `\bottomrule`. **No vertical lines**.
- **Grouping**: In the Summary Statistics table, group variables logically (e.g., Demographic Features, Policy Characteristics, and Risk Metrics).
- **Labels**: Every table and figure must have a unique `\label{tab:name}` or `\label{fig:name}` for cross-referencing.

## 4. LaTeX Syntax & Character Escaping
- **Reserved Characters:** All underscores (`_`) and percentage signs (`%`) appearing in the narrative text, table headers, or table cell contents MUST be escaped with a backslash (e.g., use `\_` and `\%`).
- **Variable Names:** Pay special attention to data variable names (e.g., `policy_id` must be written as `policy\_id`) and statistical results (e.g., `95%` must be written as `95\%`).
- **Verification:** Before finalizing the `.tex` files, perform a syntax check to ensure no raw underscores or percentage signs remain, as these will cause the `tinytex` compilation to fail.