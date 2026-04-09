# PlatinumRx Data Analyst Assignment

## Overview
This repository contains complete solutions for all three phases of the PlatinumRx Data Analyst assignment: SQL, Spreadsheets, and Python.

---

## Folder Structure
```
Data_Analyst_Assignment/
├── SQL/
│   ├── 01_Hotel_Schema_Setup.sql    # CREATE TABLE + INSERT data for Hotel system
│   ├── 02_Hotel_Queries.sql         # Hotel Q1–Q5 solutions
│   ├── 03_Clinic_Schema_Setup.sql   # CREATE TABLE + INSERT data for Clinic system
│   └── 04_Clinic_Queries.sql        # Clinic Q1–Q5 solutions
├── Spreadsheets/
│   └── README_Spreadsheet.md        # Step-by-step formula guide
├── Python/
│   ├── 01_Time_Converter.py         # Minutes → "X hrs Y minutes"
│   └── 02_Remove_Duplicates.py      # Remove duplicate chars using loop
└── README.md                        # This file
```

---

## Phase 1 – SQL

### How to Run
1. Open **MySQL Workbench** (or any SQL tool — PostgreSQL, DB Fiddle, etc.)
2. Run `01_Hotel_Schema_Setup.sql` first to create tables and insert sample data.
3. Run `02_Hotel_Queries.sql` to execute the 5 hotel queries.
4. Repeat for Clinic: run `03_Clinic_Schema_Setup.sql`, then `04_Clinic_Queries.sql`.

> **Note for MySQL users:** MySQL does not support `FULL OUTER JOIN`. The Clinic Q3 file includes a commented-out MySQL-compatible alternative using `UNION`.

### Key Techniques Used
| Question | Technique |
|----------|-----------|
| Hotel Q1 | Correlated subquery with `MAX()` |
| Hotel Q2 | Multi-table `JOIN` + `SUM(qty * rate)` |
| Hotel Q3 | `HAVING` clause after aggregation |
| Hotel Q4 | CTEs + `RANK()` window function |
| Hotel Q5 | CTEs + `DENSE_RANK()` window function |
| Clinic Q1 | `GROUP BY sales_channel` + `SUM` |
| Clinic Q2 | `GROUP BY customer` + `LIMIT 10` |
| Clinic Q3 | Two CTEs joined → profit = revenue − expense |
| Clinic Q4 | CTEs + `RANK()` partitioned by city |
| Clinic Q5 | CTEs + `DENSE_RANK()` partitioned by state |

---

## Phase 2 – Spreadsheets

See `Spreadsheets/README_Spreadsheet.md` for detailed formula instructions.

### Quick Reference
| Task | Formula |
|------|---------|
| Populate `ticket_created_at` | `=VLOOKUP(A2, ticket!$E:$B, 2, FALSE)` |
| Same-day flag | `=INT(B2)=INT(C2)` → `TRUE/FALSE` |
| Same-hour flag | `=AND(INT(B2)=INT(C2), HOUR(B2)=HOUR(C2))` |
| Count by outlet | `=COUNTIFS(sameday_col, TRUE, outlet_col, F2)` |

---

## Phase 3 – Python

### How to Run
```bash
# Time Converter
python Python/01_Time_Converter.py

# Remove Duplicates
python Python/02_Remove_Duplicates.py
```

### Sample Output
```
# Time Converter
130  →  2 hrs 10 minutes
110  →  1 hr 50 minutes
 60  →  1 hr 0 minutes

# Remove Duplicates
"programming"  →  "progamin"
"aabbcc"       →  "abc"
"hello world"  →  "helo wrd"
```

---

## Assumptions
- All SQL queries target year 2021 as per assignment scope.
- Clinic Q4 and Q5 use a configurable `@target_month` variable.
- Python scripts handle edge cases (negative input, empty string, non-integer input).
- Spreadsheet formulas assume headers are in Row 1 and data starts at Row 2.
