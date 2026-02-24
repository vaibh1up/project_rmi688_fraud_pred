# Coding & Execution Specifications

## 1. File Persistence Protocol
- **No In-Memory Only Execution:** The agent must never execute code solely in the chat/terminal session. 
- **Script Generation:** Every logical step (Audit, EDA, Modeling, Reporting) must be written to a standalone `.R` script in the `/code` folder.
- **Naming Convention:** Use a numbered prefix for execution order:
  - `02_data_audit.R`
  - `03_eda_summary.R`
  - `04_model_tournament.R`
  - `05_report_gen.R`

## 2. R Coding Standards
- **Style:** Follow `snake_case` for variables and the native pipe `|>`.
- **Header:** Every script must start with a comment header: 
  `# Purpose: [Step Name] | Author: Codex Agent | Date: [Current Date]`
- **Paths:** Always use relative paths (e.g., `data/raw/...`) to ensure the project is portable.
- **Error Handling:** Use `tryCatch()` when reading files or training models to log errors without crashing the entire agent session.

## 3. Execution Verification
- After writing a script, the agent must execute it.
- The agent must report the result of the execution (Success/Fail) and provide a snippet of the output (e.g., the first few rows of a table).