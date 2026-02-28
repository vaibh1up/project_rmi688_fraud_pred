# RMI688: Fraud Prediction Project (with AI Coding Agents)

Welcome! This project teaches you how to complete a real data science workflow using a coding agent (such as Codex or Claude Code) **even if you are new to programming**.

This README is designed to be simple, practical, and step-by-step.

---

## 1) Project Title

**Project:** Fraud Prediction & Business Payoff Optimization in R

**Purpose (in plain language):** Build a fraud detection pipeline that cleans data, compares models, chooses the best model using business payoff, and generates a management-style report.

---

## 2) What You Will Learn

By completing this project, you will learn how to:

- Use a coding agent to help write and run R scripts.
- Follow a structured analytics workflow (audit -> EDA -> modeling -> reporting).
- Evaluate model decisions using **business impact**, not just technical accuracy.
- Explain results in clear, professional language for non-technical stakeholders.

---

## 3) What Is a Coding Agent?

A coding agent is an AI assistant that can help you:

- read project instructions,
- write or edit code files,
- run scripts,
- summarize outputs,
- and help fix errors.

Think of it this way:

- **You are the project manager (decision maker).**
- **The coding agent is your technical assistant.**

Important: Do not copy results blindly. Always check whether outputs make sense.

---

## 4) Prerequisites (Before You Start)

Please make sure you have:

1. **R** installed.
2. **RStudio** installed.
3. Ability to install R packages from CRAN.
4. Opened the project using the `.Rproj` file at the repo root.

Notes:

- This project expects standard R package setup and may use `renv` where available.
- If package loading fails, ask your coding agent to install missing packages and retry.

---

## 5) Project Folder Map (Very Important)

Use this map to avoid writing files in the wrong place:

- `instructions/` -> Project rules and specs (**read-only**)
- `data/raw/` -> Original dataset (**do not edit**) 
- `data/clean/` -> Cleaned dataset outputs
- `code/` -> R scripts for each pipeline step
- `output/tables/` -> LaTeX tables
- `output/plots/` -> Figures and plots
- `draft/` -> Report sections and `main.tex`

### File safety rules

- Never let agent overwrite files in `data/raw/`.
- Never let agent modify files in `instructions/`.
- Save all generated artifacts in the expected output folders.

---

## 6) Required Workflow (Do in Order)

Your coding agent should follow this exact script order:

1. `code/02_data_audit.R`
2. `code/03_eda_summary.R`
3. `code/04_model_tournament.R`
4. `code/05_report_gen.R`

### What each step does

- **02_data_audit.R**: Reads raw data and checks whether columns match the required schema.
- **03_eda_summary.R**: Performs cleaning + summary statistics + writes EDA/cost-benefit LaTeX tables.
- **04_model_tournament.R**: Trains three models, optimizes threshold by business payoff, saves results + plot.
- **05_report_gen.R**: Generates report `.tex` sections and attempts PDF compilation.

### Non-negotiable habits

- Do not skip steps.
- Use relative paths.
- After each step, check output files and console messages.

---

## 7) How to Prompt a Coding Agent (Copy/Paste Templates)

Use prompts like these.

### Template A: Generate or fix one script only

```text
Read instructions/master.md, instructions/coding_spec.md, and instructions/data_spec.md.
Now create or update only code/02_data_audit.R.
Use relative paths and tryCatch() for file reading errors.
Do not modify any other script.
```

### Template B: Run and verify one step

```text
Run Rscript code/02_data_audit.R.
Tell me if header validation passed.
Show the key output lines and where the file outputs were saved.
```

### Template C: Debug safely

```text
The script failed. Fix only the specific error causing failure.
Do not rewrite the full pipeline.
After fixing, rerun the same script and summarize what changed.
```

### Template D: Keep agent focused

```text
Before coding, summarize the task in 3 bullets.
Then implement only what is requested.
Then list what files you changed.
```

Tip: Small, specific prompts give better results than broad prompts.

---

## 8) Success Criteria (How You Know You Are Done)

A successful submission should have all of the following:

- Data audit completed and header check result shown.
- Cleaned data file saved to `data/clean/`.
- EDA summary table and cost-benefit table saved in `output/tables/`.
- Model tournament results saved (CSV + LaTeX) in `output/tables/`.
- Payoff-threshold plot saved in `output/plots/`.
- Report section files saved in `draft/`.
- `draft/main.tex` created, with an attempted PDF compile.

If one item is missing, the pipeline is incomplete.

---

## 9) Common Mistakes (and How to Fix Them)

| Common Mistake | Why It’s a Problem | What to Do |
|---|---|---|
| Editing `data/raw/` | Breaks reproducibility and project rules | Revert changes; only write to `data/clean/` |
| Editing `instructions/` | Violates assignment constraints | Treat instructions as read-only |
| Running scripts out of order | Downstream scripts may fail or produce wrong outputs | Always run 02 -> 03 -> 04 -> 05 |
| Using only threshold 0.5 | Ignores required business-payoff optimization | Search thresholds and select max payoff |
| Agent rewrites everything | Hard to debug and verify | Ask agent to change only one file/issue at a time |
| LaTeX compile errors with `_` or `%` | Unescaped symbols can break compilation | Escape as `\_` and `\%` in narrative/table text |

---

## 10) Academic Integrity + Responsible AI Use

Using AI is allowed, but your responsibility remains the same:

- You must understand and explain your own submission.
- Keep a record of major prompts you used. You can do it in a separate text file. This of this as your prompt library.
- Verify code and outputs before submitting.
- If the agent makes a mistake, you must correct it.

A good rule: **AI can assist implementation; you are accountable for quality and correctness.**

---

## Final Advice for Beginners

- Start small.
- Run one script at a time.
- Save outputs and check folders after every step.
- If stuck, ask the coding agent to explain in plain language first, then code.
- You can also chat based LLMs for assistance on constructing better prompt and editing instruction .md files.


