-- Which departments consistently exceed or fall below capacity?
WITH capacity AS (
    SELECT
        service,
        CASE
            WHEN available_beds > patients_request THEN 0
            ELSE 1
        END AS exceed_or_fall
    FROM services_weekly sw
)
SELECT
    service,
    SUM(CASE WHEN exceed_or_fall = 1 THEN 1 ELSE 0 END) AS total_exceeds,
    SUM(CASE WHEN exceed_or_fall = 0 THEN 1 ELSE 0 END) AS total_falls
FROM capacity
GROUP BY service;

-- Conclusion: The stats show that only the emergency department is consistently exceeding the bed capacity overall.
-- Other departments are not consistently exceeding or falling below their capacity of beds.
-- KPI:
-- Service			total_exceeds	total_falls
-- general_medicine	43				9
-- surgery			30				22
-- ICU				25				27
-- emergency			52				0

-- What is the weekly bed refusal rate per service?
WITH weekly_beds AS (
    SELECT
        service,
        SUM(NULLIF(patients_refused, 0)) AS total_refusales,
        SUM(NULLIF(patients_request, 0)) AS total_requests,
        ROUND(AVG(available_beds), 2) AS avg_available_beds
    FROM services_weekly sw
    GROUP BY service
)
SELECT
    service,
    ROUND((total_refusales::NUMERIC / total_requests::NUMERIC) * 100, 2) AS refusal_rate,
    avg_available_beds
FROM weekly_beds
ORDER BY refusal_rate DESC;

-- Conclusion: The Emergency service has the highest refusal rate (around 80–81%), which indicates that it frequently reaches capacity due to the lowest average bed availability (≈22.8 beds).
-- The ICU shows the lowest refusal rate (around 17–18%), even though it has fewer available beds (≈14.9). This suggests that ICU admissions are better managed or more controlled despite high costs and limited space.
-- General Medicine has the highest average bed availability (≈46 beds), yet still records a high refusal rate (≈45%). This implies a very high patient inflow, exceeding even the higher bed capacity.
-- Surgery maintains a moderate refusal rate (≈25%) with an average of 37–38 beds available, indicating relatively balanced patient demand and resource availability.
-- KPI:
-- service           | refusal_rate | avg_available_beds
-- ----------------- | -------------| -------------------
-- emergency         | 80.87        | 22.79
-- general_medicine  | 45.39        | 46.23
-- surgery           | 24.77        | 37.52
-- ICU               | 17.87        | 14.85

-- Are shortages caused by predictable patterns (season, events, staffing gaps)?
SELECT
    event,
    COUNT(event) AS total_event_count,
    ROUND(AVG(staff_morale), 2) AS avg_staff_morale,
    ROUND(AVG(patients_admitted), 2) AS avg_admition_patients
FROM services_weekly
GROUP BY event
ORDER BY total_event_count;

-- Conclusion: There is no strong evidence that specific events (such as flu outbreaks or donations) cause consistent shortages. However, during strikes, the average staff morale drops sharply to around 53%, compared to 72–80% during other events.
-- This suggests that strikes negatively affect hospital efficiency and could indirectly influence shortages. During flu periods, despite increased patient load (≈35 patients admitted on average), staff morale remains stable (≈73%), showing that healthcare workers maintain performance even under higher demand.
-- Overall, shortages seem more correlated with staff morale fluctuations (like during strikes) rather than predictable seasonal or event-based patterns.
-- KPI:
-- event      | total_event_count | avg_staff_morale | avg_admitted_patients
-- ----------- | ----------------- | ---------------- | ---------------------
-- strike      | 11                | 53.73            | 23.91
-- donation    | 14                | 80.14            | 25.57
-- flu         | 19                | 72.89            | 35.11
-- none        | 164               | 73.15            | 27.82

-- Does low staff presence correlate with high refusal rates or low admissions?
WITH staff_presence AS (
    SELECT
        ss.week_no,
        SUM(ss.present) AS total_staff,
        SUM(sw.patients_request) AS total_requests,
        ROUND(SUM(sw.patients_admitted)::NUMERIC / SUM(sw.patients_request)::NUMERIC * 100, 2) AS admission_rates,
        ROUND(SUM(sw.patients_refused)::NUMERIC / SUM(sw.patients_request)::NUMERIC * 100, 2) AS refusal_rates
    FROM staff_schedule AS ss
    JOIN services_weekly AS sw ON ss.week_no = sw.week_no
    GROUP BY ss.week_no
)
SELECT
    ROUND(AVG(CASE WHEN total_staff = 0 THEN sp.admission_rates END), 2) AS ar_when_staff_0,
    ROUND(AVG(CASE WHEN total_staff != 0 THEN sp.admission_rates END), 2) AS ar_when_staff_not_0,
    ROUND(AVG(CASE WHEN total_staff = 0 THEN sp.refusal_rates END), 2) AS rr_when_staff_0,
    ROUND(AVG(CASE WHEN total_staff != 0 THEN sp.refusal_rates END), 2) AS rr_when_staff_not_0
FROM
    staff_presence AS sp;

-- Conclusion: When staff presence drops to 0, admission rates fall by 3–4% and refusal rates increase by 3%, clearly showing staff shortage directly reduces hospital efficiency.
-- KPI:
-- ar_when_staff_0	ar_when_staff_not_0		rr_when_staff_0		rr_when_staff_not_0
-- 44.35				47.96					55.65				52.04

-- Which roles/services face chronic understaffing or overstaffing?
SELECT
    ss.service,
    ss.staff_role,
    SUM(ss.present) AS total_staff
FROM staff_schedule AS ss
JOIN services_weekly AS sw ON ss.week_no = sw.week_no
GROUP BY ss.service, ss.staff_role
ORDER BY ss.service ASC;

-- Conclusion: Analysis of total staff presence by service and role indicates that surgery doctors are the most chronically understaffed group, with only 384 total presence counts compared to nurses and assistants in the same department.
-- Conversely, emergency nurses appear overstaffed, with the highest presence count (2,780), likely reflecting the hospital’s focus on emergency preparedness.
-- Overall, this imbalance suggests the need for better staff reallocation across departments, ensuring that critical services like surgery have adequate doctor availability.

-- Are morale drops linked to workload pressure or specific events?
WITH morale_analysis AS (
    SELECT
        sw.event,
        ROUND(AVG(sw.staff_morale), 2) AS avg_staff_morale,
        ROUND(AVG(sw.patients_admitted), 2) AS avg_patients_admitted,
        ROUND(AVG(sw.patients_request), 2) AS avg_patients_request,
        ROUND(AVG(sw.patients_refused), 2) AS avg_patients_refused,
        ROUND(AVG(sw.available_beds), 2) AS avg_available_beds
    FROM services_weekly sw
    GROUP BY sw.event
)
SELECT
    event,
    avg_staff_morale,
    avg_patients_admitted,
    avg_patients_request,
    avg_patients_refused,
    avg_available_beds
FROM morale_analysis
ORDER BY avg_staff_morale;

-- Conclusion: The “strike” event clearly correlates with a major morale drop (~54%) compared to the others (72–80%).
-- Even though workload (patients requested/admitted) fluctuates, the biggest morale decrease appears tied to external event stress, not workload pressure.
-- During flu or donation events, morale remains high, proving internal motivation and purpose-driven context (like donation) support morale. Hence, morale drop is event-driven (strike), not workload-driven.

-- What is the average length of stay by department?
SELECT
    service,
    ROUND(AVG(departure_date - arrival_date), 2) AS avg_stay
FROM
    patients p
GROUP BY service;

-- Conclusion: Overall the avg length of stay by department is 7 days.
-- KPI:
-- service			avg_stay
-- general_medicine	7.00
-- surgery			7.87
-- ICU				7.61
-- emergency			7.16

-- Which services deliver highest vs. lowest satisfaction?
SELECT
    service,
    ROUND(AVG(p.satisfaction), 2) AS avg_satisfaction
FROM
    patients p
GROUP BY service
ORDER BY avg_satisfaction;

-- Conclusion: Surgery patients report the highest satisfaction, possibly due to clear, result-oriented treatments and focused post-operative care.
-- General Medicine shows the lowest satisfaction, which could indicate challenges in communication, longer waiting times, or less predictable outcomes compared to surgical departments.
-- KPI:
-- Highest Satisfaction: Surgery – 80.31%
-- Lowest Satisfaction: General Medicine – 78.57%

-- Do long stays or rejections affect satisfaction?
WITH long_short_stays AS (
    SELECT
        service,
        CASE WHEN (departure_date - arrival_date) > 7 THEN (departure_date - arrival_date) ELSE 0 END AS long_stay,
        CASE WHEN (departure_date - arrival_date) > 7 THEN satisfaction ELSE 0 END AS long_stay_sat,
        CASE WHEN (departure_date - arrival_date) < 7 THEN (departure_date - arrival_date) ELSE 0 END AS short_stay,
        CASE WHEN (departure_date - arrival_date) < 7 THEN satisfaction ELSE 0 END AS short_stay_sat
    FROM
        patients p
)
SELECT
    service,
    ROUND(AVG(long_stay), 2) AS avg_long_stay,
    ROUND(AVG(long_stay_sat), 2) AS avg_long_stay_sat,
    ROUND(AVG(short_stay), 2) AS avg_short_stay,
    ROUND(AVG(short_stay_sat), 2) AS avg_short_stay_sat
FROM
    long_short_stays
GROUP BY service;

-- KPI:
-- service			avg_long_stay	avg_long_stay_sat	avg_short_stay	avg_short_stay_sat
-- general_medicine	4.87			35.57				1.60			37.23
-- surgery			5.93			43.61				1.24			28.91
-- ICU				5.56			40.76				1.52			33.32
-- emergency			4.98			37.79				1.75			36.91

-- If demand increases, which services should receive additional staff or beds first?
-- Conclusion: If demand increases, then service Emergency should receive additional beds first because analysis shows that Emergency exceeds its capacity consistently over the year for every week.
-- And the Emergency also is the service which has the highest 80% to 81% Refusal rate.

-- Can staff be reallocated across departments to reduce refusals?
-- Conclusion: Even though the Emergency mostly exceeds its capacity, there is a much higher number of nurses appearing overstaffed, with the highest presence count (2,780).
-- Surgery doctors are the most chronically understaffed group, with only 384 total presence counts compared to nurses and assistants in the same department.
-- So the Answer is Yes, Staff should be reallocated across departments to reduce refusals.

-- Should priority-based admission rules be introduced?
-- Conclusion: Yes, there is no doubt about that. The most important department is Emergency.
-- And that also is the department which had no beds for additional patients.
-- So priority-based admission rules should be not just introduced but should be implemented immediately.