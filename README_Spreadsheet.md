# Spreadsheet Solutions – Step-by-Step Guide

## Setup
1. Open Excel or Google Sheets.
2. Create two sheets named **`ticket`** and **`feedbacks`**.
3. Paste the sample data below into each sheet.

---

## Sample Data

### Sheet: `ticket`  (columns A–E)
| ticket_id   | created_at              | closed_at               | outlet_id    | cms_id      |
|-------------|-------------------------|-------------------------|--------------|-------------|
| isu-sjd-457 | 2021-08-19 16:45:43     | 2021-08-22 12:33:32     | wrqy-juv-978 | vew-iuvd-12 |
| qer-fal-092 | 2021-08-21 11:09:22     | 2021-08-21 17:13:45     | 8woh-k3u-23b | cms-abc-001 |
| tyu-ghj-301 | 2021-08-23 09:15:00     | 2021-08-23 09:55:00     | wrqy-juv-978 | cms-def-002 |
| mnb-vcp-412 | 2021-08-24 14:00:00     | 2021-08-25 10:30:00     | 8woh-k3u-23b | cms-ghi-003 |
| zxc-lkj-523 | 2021-08-25 08:30:00     | 2021-08-25 08:55:00     | wrqy-juv-978 | cms-jkl-004 |

### Sheet: `feedbacks`  (columns A–D)
| cms_id      | feedback_at             | feedback_rating | ticket_created_at |
|-------------|-------------------------|-----------------|-------------------|
| vew-iuvd-12 | 2021-08-21 13:26:48     | 3               | (to be filled)    |
| cms-abc-001 | 2021-08-22 10:00:00     | 5               | (to be filled)    |
| cms-def-002 | 2021-08-24 09:00:00     | 4               | (to be filled)    |

---

## Question 1 – Populate `ticket_created_at` in feedbacks sheet

**Goal:** Look up the `created_at` value from the `ticket` sheet using `cms_id` as the key.

### VLOOKUP Formula
In cell **D2** of the `feedbacks` sheet, enter:

```excel
=VLOOKUP(A2, ticket!$E:$B, 2, FALSE)
```

**How it works:**
- `A2` → the `cms_id` in the current feedbacks row (lookup value)
- `ticket!$E:$B` → look in the `ticket` sheet, columns E (cms_id) to B (created_at)
- `2` → return the 2nd column of that range, which is `created_at`
- `FALSE` → exact match only

> **Tip (more robust alternative with INDEX-MATCH):**
> ```excel
> =INDEX(ticket!$B:$B, MATCH(A2, ticket!$E:$E, 0))
> ```
> This is better when columns might be reordered.

**Drag the formula** down to D3, D4 … for all feedback rows.

---

## Question 2 – Count tickets created AND closed on the same day / same hour

### Step 1 – Add helper columns to the `ticket` sheet

Go to the `ticket` sheet. Add these columns starting at column F:

#### Column F – "Same Day?"
In **F2**, enter:
```excel
=INT(B2) = INT(C2)
```
- `INT()` strips the time part, leaving only the date serial number.
- Returns `TRUE` if created and closed on the same calendar day.

#### Column G – "Same Hour?"
In **G2**, enter:
```excel
=AND(INT(B2) = INT(C2),  HOUR(B2) = HOUR(C2))
```
- First condition: same day (date parts match).
- Second condition: same hour within that day.
- Returns `TRUE` only when BOTH conditions are met.

Drag both formulas down to cover all data rows.

---

### Step 2 – Count per outlet using COUNTIFS

Create a summary table (e.g., starting at column I):

| (I1) outlet_id   | (J1) Same Day Count | (K1) Same Hour Count |
|------------------|---------------------|----------------------|
| wrqy-juv-978     | =formula            | =formula             |
| 8woh-k3u-23b     | =formula            | =formula             |

#### Same Day Count – cell J2:
```excel
=COUNTIFS($D$2:$D$1000, I2,  $F$2:$F$1000, TRUE)
```

#### Same Hour Count – cell K2:
```excel
=COUNTIFS($D$2:$D$1000, I2,  $G$2:$G$1000, TRUE)
```

- `$D$2:$D$1000` → the `outlet_id` column
- `I2` → the outlet we are counting for
- `$F$2:$F$1000` → the "Same Day?" helper column
- `TRUE` → count only rows flagged TRUE

---

### Alternative: Pivot Table approach

1. Select all ticket data (A1 to G-last-row).
2. Insert → Pivot Table.
3. Rows: `outlet_id`.
4. Values: **Count of "Same Day?"** filtered to show only `TRUE` → this gives the same-day count.
5. Repeat for "Same Hour?" for the same-hour count.

---

## Summary of All Formulas

| Task | Formula |
|------|---------|
| Lookup `ticket_created_at` (VLOOKUP) | `=VLOOKUP(A2, ticket!$E:$B, 2, FALSE)` |
| Lookup `ticket_created_at` (INDEX-MATCH) | `=INDEX(ticket!$B:$B, MATCH(A2, ticket!$E:$E, 0))` |
| Same-day helper | `=INT(B2)=INT(C2)` |
| Same-hour helper | `=AND(INT(B2)=INT(C2), HOUR(B2)=HOUR(C2))` |
| Outlet same-day count | `=COUNTIFS($D$2:$D$1000, I2, $F$2:$F$1000, TRUE)` |
| Outlet same-hour count | `=COUNTIFS($D$2:$D$1000, I2, $G$2:$G$1000, TRUE)` |
