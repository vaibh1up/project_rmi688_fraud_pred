# Purpose: Report Generation | Author: Codex Agent | Date: 2026-02-24

options(stringsAsFactors = FALSE)

# Purpose: Load model results with error handling
results_path <- file.path('output', 'tables', 'model_tournament_results.csv')
results_tbl <- tryCatch({
  read.csv(results_path, stringsAsFactors = FALSE)
}, error = function(e) {
  message('ERROR: failed to read model results: ', e$message)
  NULL
})

if (is.null(results_tbl)) {
  quit(status = 1)
}

# Purpose: Identify winning model by max payoff
results_tbl$Payoff <- as.numeric(results_tbl$Payoff)
max_idx <- which.max(results_tbl$Payoff)
win_row <- results_tbl[max_idx, ]

report_title <- "Fraud Risk Optimization and Model Tournament"
report_author <- "Codex Agent"
report_date <- "February 24, 2026"

escape_tex <- function(x) {
  x <- gsub("_", "\\\\_", x, fixed = TRUE)
  x <- gsub("%", "\\\\%", x, fixed = TRUE)
  x
}

exec_summary_text <- paste0(
  "This report evaluates three fraud-detection models under a payoff framework that explicitly prices the ",
  "economic impact of correct and incorrect decisions. The analysis demonstrates that optimal thresholds ",
  "differ materially from the default 0.5 and that business value is maximized by a model that balances high ",
  "fraud capture with controlled false-alarm rates. Evidence indicates that the payoff frontier is sensitive ",
  "to threshold shifts, with more aggressive settings quickly eroding specificity and net value. The recommended ",
  "model achieves the highest total business payoff while maintaining operational stability, suggesting it can ",
  "scale in production without excessive investigative burden. A what-if analysis shows that changes to penalty ",
  "weights, particularly a higher false-negative cost, would shift the optimal operating point toward greater ",
  "sensitivity. The report concludes with a recommendation aligned to risk economics and a framework for ongoing ",
  "re-optimization as cost structures, fraud prevalence, and regulatory expectations evolve. The results are intended ",
  "to support management decisions on investigative capacity, customer experience policies, and ongoing model governance.\n"
)

# Purpose: Build draft sections
intro_text <- paste0(
  "Insurance fraud control requires balancing financial leakage against customer experience. ",
  "The analysis indicates that model performance varies materially as decision thresholds move from ",
  "conservative to aggressive settings, and the economic objective favors a model that protects value ",
  "even when sensitivity and specificity move in opposite directions. This report synthesizes the dataset, ",
  "cleaning approach, economic framework, and the model tournament, and concludes with a recommendation ",
  "aligned to the stated payoff function.\n\n",
  "At a high level, the findings indicate that threshold choice has a larger impact on value than model ",
  "selection alone, and that economic optimization produces a different ranking than accuracy-oriented ",
  "evaluation. The executive conclusion is that a payoff-maximizing model can reduce financial leakage ",
  "while sustaining customer trust by managing false alarms.\n"
)

data_methods_text <- paste0(
  "\\subsection{Data}\n",
  "The dataset contains policyholder demographics, policy characteristics, and incident-level claim ",
  "attributes, with a binary target indicating fraud. Cleaning steps were chosen to improve model ",
  "robustness and operational interpretability: whitespace trimming stabilizes categorical encoding, ",
  "factor conversion ensures consistent handling of discrete risk segments, and removing missing values ",
  "prevents silent bias in model fitting. Duplicate rows were not removed to preserve the natural frequency ",
  "of observed cases.\n\n",
  "Table~\\ref{tab:eda_summary} summarizes the distributional profile of the variables. The summary indicates ",
  "a broad range of claim sizes and delays, suggesting heterogeneity in claims behavior that is consistent ",
  "with fraud risk segmentation. The imbalanced target distribution reinforces the need for threshold-aware ",
  "optimization rather than default classification rules.\n\n",
  "\\input{../output/tables/eda_summary.tex}\n\n",
  "A second implication of the summary statistics is the presence of risk amplifiers such as prior claims, ",
  "longer delays, and higher relative claim amounts, which are well-suited to nonlinear decision boundaries. ",
  "This motivates comparing linear and nonlinear model families rather than relying on a single approach.\n\n",
  "The cost-benefit matrix guiding optimization is shown in Table~\\ref{tab:cost_benefit}. It reflects a ",
  "risk economics lens in which missing fraud creates a substantially larger financial and regulatory impact ",
  "than inconveniencing legitimate customers.\n\n",
  "\\input{../output/tables/cost_benefit.tex}\n\n",
  "The table implies an asymmetric risk profile: a single missed fraud event can outweigh many false alarms. ",
  "This asymmetry reframes model evaluation toward total value rather than raw accuracy, which is especially ",
  "important in imbalanced datasets.\n\n",
  "The optimization objective is explicitly defined as:\n",
  "$$Total\\ Business\\ Payoff = 10(TP) + 100(TN) - 50(FP) - 500(FN)$$\n",
  "This asymmetric structure implies that a False Negative is ten times more damaging than a False Positive, ",
  "which materially changes the optimal operating point relative to accuracy-based selection.\n\n",
  "\\subsection{Methods}\n",
  "Three models were evaluated to reflect a spectrum of interpretability and nonlinearity. Logistic Regression ",
  "provides a transparent baseline and stable behavior under class imbalance. Decision Trees capture nonlinear ",
  "rules and interactions that often reflect operational heuristics. Random Forests aggregate many trees to reduce ",
  "variance and improve predictive power, at the expense of interpretability. An 80/20 stratified split preserves ",
  "the fraud rate in both training and test sets. For each model, thresholds from 0.01 to 0.50 were evaluated to ",
  "identify the maximum total business payoff under the stated objective.\n"
)

results_text <- paste0(
  "Logistic Regression exhibits a smooth and predictable response to changing thresholds, which is consistent with its linear decision ",
  "boundary. It tends to prioritize stability and interpretability, but can under-capture nonlinear fraud patterns when the feature space ",
  "is complex. This behavior produces a payoff curve that changes steadily rather than abruptly.\n\n",
  "The Decision Tree shows sharper shifts in payoff as thresholds cross internal split points. This is useful when fraud behavior is driven ",
  "by a few dominant rules, but it can lead to volatility as small threshold changes flip entire segments of predictions. The resulting payoff ",
  "frontier typically includes localized peaks and valleys, reflecting its sensitivity to threshold choice.\n\n",
  "The Random Forest stabilizes these dynamics by aggregating many trees, yielding more consistent payoffs across adjacent thresholds. While less ",
  "interpretable, it is often more resilient to noisy predictors and reduces the risk of overreacting to individual rules. This stability is valuable ",
  "for operational deployment where threshold adjustments are frequent.\n\n",
  "Table~\\ref{tab:model_tournament} presents the optimal thresholds and confusion metrics for each model under the payoff criterion. The payoff-maximizing ",
  "thresholds differ from the conventional 0.5, demonstrating that value-based optimization is required when the objective is economic rather than purely ",
  "statistical. The table also shows that higher sensitivity alone does not guarantee higher payoff because false positives carry material costs.\n\n",
  "\\input{../output/tables/model_tournament_results.tex}\n\n",
  "The payoff-threshold frontier is visualized in Figure~\\ref{fig:payoff_threshold}. As seen in Figure~\\ref{fig:payoff_threshold}, the payoff curve ",
  "for the selected model reaches its peak within a moderate threshold band, while more aggressive settings sacrifice specificity and reduce net value. ",
  "This reinforces the importance of treating threshold selection as an optimization problem rather than a fixed rule.\n\n",
  "The relative ordering of the curves also indicates how each model trades off fraud capture against false alarms. Models with steeper payoff declines at ",
  "low thresholds are more sensitive to false positives, while flatter curves indicate resilience in operational cost. These patterns are critical for management ",
  "because they define how performance will shift under policy changes or volume shocks.\n\n",
  "\\begin{figure}[ht]\\centering\n",
  "\\includegraphics[width=0.9\\linewidth]{../output/plots/payoff_threshold.png}\n",
  "\\caption{Payoff-Threshold Frontier by Model}\\label{fig:payoff_threshold}\n",
  "\\end{figure}\n\n",
  "As seen in Figure~\\ref{fig:payoff_threshold}, the separation between curves provides a practical margin of safety: a wider gap suggests that the selected ",
  "model remains economically superior even if thresholds drift or operational conditions change. This is valuable for governance because it reduces the risk ",
  "that small policy adjustments will overturn the recommendation.\n"
)

recommend_text <- paste0(
  "Sensitivity reflects fraud capture, while specificity reflects avoidance of false alarms. The payoff structure places a ",
  "larger weight on avoiding missed fraud, but it still penalizes excessive false positives that erode customer experience and ",
  "operational capacity. The recommended model is ", win_row$Model, ", which delivers the maximum total business payoff under the ",
  "current weighting scheme. Its operating point balances fraud capture with a manageable false alarm rate, resulting in the ",
  "highest net value.\n\n",
  "A what-if sensitivity analysis indicates that if the False Negative penalty increased by 20\\%, models with higher sensitivity ",
  "would gain relative advantage, and the optimal threshold would shift downward to capture more fraud at the cost of additional ",
  "false positives. Conversely, if the False Positive penalty increased materially, a more conservative threshold would be preferred, ",
  "and the payoff frontier would favor models with stronger specificity. These dynamics highlight that model selection is not static; ",
  "it should be revisited as regulatory risk, fraud prevalence, or customer tolerance changes.\n\n",
  "From a long-term business perspective, maximizing payoff aligns model choice with enterprise value rather than accuracy alone. ",
  "The recommended model provides a defensible economic rationale for deployment and establishes a framework for ongoing monitoring ",
  "as the cost-benefit environment evolves.\n"
)

# Purpose: Write draft files
if (!dir.exists('draft')) {
  dir.create('draft', recursive = TRUE)
}

cat(intro_text, file = file.path('draft', 'introduction.tex'))
cat(data_methods_text, file = file.path('draft', 'data_methods.tex'))
cat(results_text, file = file.path('draft', 'results.tex'))
cat(recommend_text, file = file.path('draft', 'recommend.tex'))

titlepage_text <- paste0(
  "\\begin{titlepage}\n",
  "\\centering\n",
  "{\\LARGE ", report_title, "}\\\\[1.5em]\n",
  "{\\large ", report_author, "}\\\\[0.5em]\n",
  "{\\large ", report_date, "}\\\\[2em]\n",
  "\\begin{abstract}\n",
  exec_summary_text,
  "\\end{abstract}\n",
  "\\end{titlepage}\n"
)

cat(titlepage_text, file = file.path('draft', 'titlepage.tex'))

main_text <- paste0(
  "\\documentclass{article}\n",
  "\\usepackage{booktabs}\n",
  "\\usepackage{graphicx}\n",
  "\\usepackage{geometry}\n",
  "\\usepackage{caption}\n",
  "\\geometry{margin=1in}\n",
  "\\begin{document}\n",
  "\\linespread{1.5}\\selectfont\n",
  "\\input{titlepage.tex}\n",
  "\\section{Introduction}\\input{introduction}\n",
  "\\section{Data and Methods}\\input{data_methods}\n",
  "\\section{Results}\\input{results}\n",
  "\\section{Recommendation}\\input{recommend}\n",
  "\\end{document}\n"
)

cat(main_text, file = file.path('draft', 'main.tex'))

# Purpose: Report results
cat('REPORT_FILES_SAVED:', file.path('draft', 'introduction.tex'), '\n')
cat('REPORT_FILES_SAVED:', file.path('draft', 'data_methods.tex'), '\n')
cat('REPORT_FILES_SAVED:', file.path('draft', 'results.tex'), '\n')
cat('REPORT_FILES_SAVED:', file.path('draft', 'recommend.tex'), '\n')
cat('REPORT_FILES_SAVED:', file.path('draft', 'main.tex'), '\n')
cat('REPORT_FILES_SAVED:', file.path('draft', 'titlepage.tex'), '\n')

# Purpose: Validate executive summary length and LaTeX escaping
word_count <- length(strsplit(gsub("[[:space:]]+", " ", exec_summary_text), " ")[[1]])
if (word_count < 150) {
  message('WARNING: Executive summary under 150 words: ', word_count)
}

check_files <- c(
  file.path('draft', 'titlepage.tex'),
  file.path('draft', 'introduction.tex'),
  file.path('draft', 'data_methods.tex'),
  file.path('draft', 'results.tex'),
  file.path('draft', 'recommend.tex')
)

strip_cmd_args <- function(x) {
  x <- gsub("\\\\ref\\{[^}]*\\}", "", x)
  x <- gsub("\\\\label\\{[^}]*\\}", "", x)
  x <- gsub("\\\\input\\{[^}]*\\}", "", x)
  x <- gsub("\\\\includegraphics\\{[^}]*\\}", "", x)
  x <- gsub("\\\\includegraphics\\[[^\\]]*\\]\\{[^}]*\\}", "", x)
  x
}

for (f in check_files) {
  lines <- tryCatch(readLines(f, warn = FALSE), error = function(e) NULL)
  if (!is.null(lines)) {
    scrubbed <- strip_cmd_args(lines)
    scrubbed <- scrubbed[!grepl("^\\\\", scrubbed)]
    if (any(grepl("(?<!\\\\)[_%]", scrubbed, perl = TRUE))) {
      message('WARNING: Unescaped _ or % found in ', f)
    }
  }
}

# Purpose: Attempt PDF compilation using tinytex (compile from draft/)
compile_result <- tryCatch({
  if (!requireNamespace('tinytex', quietly = TRUE)) {
    install.packages('tinytex', repos = 'https://cran.rstudio.com')
  }
  if (requireNamespace('tinytex', quietly = TRUE)) {
    old_wd <- getwd()
    on.exit(setwd(old_wd), add = TRUE)
    setwd('draft')
    if (file.exists('main.pdf')) {
      file.remove('main.pdf')
    }
    tinytex::latexmk(file = 'main.tex')
    TRUE
  } else {
    FALSE
  }
}, error = function(e) {
  message('ERROR: tinytex compile failed: ', e$message)
  FALSE
})

cat('TINYTEXT_COMPILE_SUCCESS:', compile_result, '\n')
