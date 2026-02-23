# Project Master: Fraud Prediction & Reporting

## 1. Objective
Automate an end-to-end data science pipeline in R that:
1. Cleans and prepares a fraud dataset.
2. Evaluates three competing models (Logistic Regression, Decision Tree, and Random Forest).
3. Selects the optimal model based on a weighted Cost-Benefit analysis.
4. Generates a management-ready performance report in LaTeX.

## 2. Agent Workflow Protocol
The Agent must follow these steps in order:
1. **Env Check:** Read `env_config.md`. Install/Load all required R libraries.
2. **Data Audit:** Read `data_spec.md`. Understand and Verify the CSV header matches the specification.
3. **Exploratory Analysis:** Generate summary statistics for all variables (mean, median, min, max, 25%ile, 75%ile).
4. **Model Tournament & Economic Optimization:**
   - **Data Split:** Perform an 80/20 stratified split (to preserve fraud class proportions).
   - **Training:** Train three models: Logistic Regression, Decision Tree, and Random Forest.
   - **Threshold Optimization:** - Do NOT use the default 0.5 probability threshold.
     - For each model, iterate through a range of probability thresholds (e.g., 0.01 to 0.50).
     - Calculate the "Total Business Cost" at each threshold using the formula in `data_spec.md`.
     - Select the threshold for each model that yields the **Minimum Total Business Cost**.
   - **Evaluation:** - Using the optimal threshold, calculate the final Confusion Matrix.
     - Report Sensitivity and Specificity.
     - Compare the three models based on their "Minimised Cost" performance.

## 5. Report Generation
- **Requirement:** Follow the structure and formatting defined in `instructions/report_spec.md`.
- **Output:** All `.tex` files must be saved to `/draft`. All tables to `/output/tables`.
- **Integration:** Ensure `main.tex` correctly uses `\input{}` to pull in the modular sections (introduction, results, etc.).


## 3. Directory Map
- `/data/raw`: Contains the data `training_subsample_30- Inclass Dataset.csv`.
- `/data/clean`: clean data (if saved separately) go here.
- `/code`: All generated `.R` scripts go here.
- `/output/tables`: All `.tex` tables go here.
- `/output/plots`: All figures and plots go here.
- `/draft`: all report tex files go here.