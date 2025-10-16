# Hospital Resource & Patient Flow Optimization — A Business Analytics Project

## Project Brief

This project serves as a business analytics task focused on improving operational efficiency for a mid-sized hospital group. As a Data Analyst, the objective is to analyze hospital bed utilization, staff allocation, and patient experience using a set of synthetic datasets. The final goal is to provide data-backed recommendations that improve capacity management, staff morale, and patient satisfaction.

This repository contains the complete SQL workflow, from schema creation and data cleaning to in-depth analysis aimed at answering critical business questions.

---

## 📂 Available Datasets
##### [Hospital Beds Management](https://www.kaggle.com/datasets/jaderz/hospital-beds-management?)
The analysis is based on four key datasets:

| File Name             | Description                                                   | Key Columns                                                                                               |
| --------------------- | ------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| `staff_schedule.csv`  | Weekly presence records of hospital staff                     | `week`, `staff_id`, `role`, `service`, `present`                                                          |
| `staff.csv`           | Master list of staff members                                  | `staff_id`, `staff_name`, `role`, `service`                                                               |
| `services_weekly.csv` | Weekly hospital service capacity & performance metrics        | `week`, `service`, `available_beds`, `patients_request`, `patients_admitted`, `patients_refused`, `event` |
| `patients.csv`        | Patient visit details and satisfaction                        | `patient_id`, `arrival_date`, `departure_date`, `service`, `satisfaction`                                 |

---

## 🎯 Business Objectives

The analysis is structured to help management answer the following key questions across four domains:

#### 1️⃣ Capacity & Bed Utilization
- Which departments consistently exceed or fall below capacity?
- What is the weekly bed refusal rate per service?
- Are shortages caused by predictable patterns (season, events, staffing gaps)?

#### 2️⃣ Staffing Efficiency & Workforce Planning
- Does low staff presence correlate with high refusal rates or low admissions?
- Which roles/services face chronic understaffing or overstaffing?
- Are morale drops linked to workload pressure or specific events?

#### 3️⃣ Patient Flow & Experience
- What is the average length of stay by department?
- Which services deliver highest vs. lowest satisfaction?
- Do long stays or rejections affect satisfaction?

#### 4️⃣ Actionable Strategy & Recommendation Layer
- If demand increases, which services should receive additional staff or beds first?
- Can staff be reallocated across departments to reduce refusals?
- Should priority-based admission rules be introduced?

---

## ⚙️ Project Structure & Workflow

This repository is organized into three main SQL files that represent the project's workflow:

1.  **[`schema.sql`](./schema.sql)**: This file contains the SQL Data Definition Language (DDL) to create the database schema. It defines the structure, data types, and primary keys for the four tables (`patients`, `servies_weekly`, `staff`, `staff_schedule`).

2.  **[`data_cleaning.sql`](./data_cleaning.sql)**: This script performs initial data integrity checks, specifically by querying for `NULL` values across all tables. The investigation concluded that the dataset is clean and complete, with zero null values, which is expected as it is a synthetic dataset designed for analysis.

3.  **[`analysis.sql`](./analysis.sql)**: The core of the project, this file contains all the SQL queries used to address the business objectives. Each query is followed by a conclusion derived from its results, including Key Performance Indicators (KPIs) and analytical insights.

---

## ✅ Final Deliverables

This repository itself serves as the final deliverable, containing:

| Deliverable                      | Format                |
| -------------------------------- | --------------------- |
| Database Schema Definition       | `schema.sql`          |
| Data Cleaning & Integrity Checks | `data_cleaning.sql`   |
| Business Insight Analysis        | `analysis.sql`        |
| Project Overview & Documentation | `README.md` (this file) |

---

## 💡 Suggestion Panel (Consultant's View)

This section provides critical thinking and data-driven answers to strategic questions, simulating a realistic consultant-style engagement.

#### 1. If the hospital could only invest in ONE department (service) next quarter, which one should it be and why?
The investment priority should unequivocally be the **Emergency** department. The analysis shows it is the most critical bottleneck, operating at overcapacity for 100% of the year and exhibiting an alarmingly high patient refusal rate of **80.87%**. Investing here would have the most significant impact on improving patient access to care and managing hospital-wide patient flow.

#### 2. If forced to choose between hiring more staff vs. adding more beds — what would you recommend, based on data?
Based on the data, the immediate priority should be **optimizing staff allocation and hiring for key roles**, rather than simply adding beds. The analysis revealed a direct correlation between staff presence and admission rates—a total absence of staff leads to a **3-4% drop in admissions**. Furthermore, there is a clear misallocation: the Emergency department is overstaffed with nurses, while Surgery is chronically understaffed with doctors. Adding beds without the specialized staff to service them would be an inefficient use of capital. The first step is to reallocate existing staff and then hire strategically for understaffed roles like surgeons.

#### 3. What additional data would you request from the hospital to improve the accuracy of your conclusions?
To deepen the analysis, I would request the following:
- **Patient Acuity Scores:** To differentiate between high-severity and low-severity cases, which would justify resource allocation better.
- **Detailed Timestamps:** Exact admission and discharge times (not just dates) to calculate the average length of stay with greater precision.
- **Staff Shift & Overtime Data:** To get a more accurate picture of workload and potential burnout, which morale scores only hint at.
- **Patient Demographics & Diagnosis Codes (ICD-10):** To identify patterns in patient cases and seasonal demand (e.g., respiratory illnesses in winter).
- **Hospital Financial Data:** Cost per bed per day, staff salaries, and revenue per service to conduct a cost-benefit analysis of any recommendations.

#### 4. If you had to build an early warning system (alerts for bed shortages or morale drops), which 3 metrics would you track weekly?
An effective early warning system should track leading indicators of operational stress. I would recommend monitoring:
1.  **Weekly Refusal Rate by Service:** A direct measure of unmet patient demand. An alert could be triggered if the rate for any service exceeds a predefined threshold (e.g., >25%).
2.  **Weekly Staff Morale Score (by Service):** A leading indicator of potential burnout, strikes, or systemic issues. A sharp drop below the historical average (e.g., below 65) would trigger an alert for management intervention.
3.  **Bed Occupancy Rate (Available Beds vs. Patients Requested):** This real-time capacity metric is crucial. An alert should be triggered when the number of patients requesting admission surpasses 95% of available beds, allowing for proactive load-balancing measures.
