# Project Master: Fraud Prediction & Reporting

## 0. Permissions & Constraints (CRITICAL)
- **Read-Only:** `/data/raw` and `/instructions`. The Agent is strictly forbidden from modifying or deleting files in these folders.
- **Write-Access:** `/code`, `/output`, `/draft`, and `/data/clean`.
- **Data Integrity:** Do not overwrite the raw CSV. Any cleaned data must be saved as a new file in `/data/clean`.

## 1. Objective
Automate an end-to-end data science pipeline in R that:
1. Cleans and prepares a fraud dataset.
2. Evaluates three competing models (Logistic Regression, Decision Tree, and Random Forest).
3. Selects the optimal model based on a weighted Cost-Benefit analysis.
4. Generates a management-ready performance report in LaTeX.

## 2. Agent Workflow Protocol
**Standard Operating Procedure:** Before execution, the agent must read `instructions/coding_spec.md` and adhere to the File Persistence Protocol and Naming Conventions for all generated scripts.
The Agent must follow these steps in order:
1. **Env Check:** Read `env_config.md`. Install/Load all required R libraries.
2. **Data Audit:** Read `data_spec.md`. Understand and Verify the CSV header matches the specification.
3. **Exploratory Analysis:** Generate summary statistics for all variables (mean, median, min, max, 25%ile, 75%ile).
4. **Model Tournament & Economic Optimization:**
   - **Data Split:** Perform an 80/20 stratified split (to preserve fraud class proportions).
   - **Training:** Train three models: Logistic Regression, Decision Tree, and Random Forest.
   - **Threshold Optimization:** - Do NOT use the default 0.5 probability threshold.
     - For each model, iterate through a range of probability thresholds (e.g., 0.01 to 0.50).
     - Calculate the "Total Business Payoff" at each threshold using the formula in `data_spec.md`.
     - Select the threshold for each model that yields the **Maximum Total Business Payoff**.
   - **Evaluation:** - Using the optimal threshold, calculate the final Confusion Matrix.
     - Report Sensitivity and Specificity.
     - Compare the three models based on their "Maximum payoff" performance.

5. Report Generation
- **Requirement:**  Follow the structure and formatting defined in `instructions/report_spec.md`. Note: Use the report_spec.md as a structural guide, but ensure the narrative flows logically.
- **Output:** All `.tex` files must be saved to `/draft`. All tables to `/output/tables`.
- **Integration:** Ensure `main.tex` correctly uses `\input{}` to pull in the modular sections (introduction, results, etc.).
- **Final Action:** The last script (`05_report_gen.R`) must attempt to compile `main.tex` using tinytex

## 3. Artifact Integrity & Versioning
- **Static Artifacts:** Once a table (e.g., `eda_summary.tex`) is generated and verified, the agent must NOT recreate it in later steps.
- **Reference Only:** Step 5 Report Gen must only write the narrative text and use LaTeX `\input{}` or `\include{}` to reference existing files in `/output/tables`.
- **Naming Consistency:** Artifact names must be fixed and defined in the script (e.g., `winning_model_results.tex`). If a script is re-run, it should overwrite the existing file.


## 4. Directory Map
- `/data/raw`: Contains the data `training_subsample_30- Inclass Dataset.csv`.
- `/data/clean`: clean data (if saved separately) go here.
- `/code`: All generated `.R` scripts go here.
- `/output/tables`: All `.tex` tables go here.
- `/output/plots`: All figures and plots go here.
- `/draft`: all report tex files go here.