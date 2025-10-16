-- Check for NULL values in the patients table
SELECT
    COUNT(*) FILTER (WHERE patient_id IS NULL) AS patient_id_null,
    COUNT(*) FILTER (WHERE name IS NULL) AS name_null,
    COUNT(*) FILTER (WHERE age IS NULL) AS age_null,
    COUNT(*) FILTER (WHERE arrival_date IS NULL) AS arrival_date_null,
    COUNT(*) FILTER (WHERE departure_date IS NULL) AS departure_date_null,
    COUNT(*) FILTER (WHERE service IS NULL) AS service_null,
    COUNT(*) FILTER (WHERE satisfaction IS NULL) AS satisfaction_null
FROM patients;

-- Check for NULL values in the services_weekly table
SELECT
    COUNT(*) FILTER (WHERE week_no IS NULL) AS week_no_null,
    COUNT(*) FILTER (WHERE month_no IS NULL) AS month_no_null,
    COUNT(*) FILTER (WHERE service IS NULL) AS service_null,
    COUNT(*) FILTER (WHERE available_beds IS NULL) AS available_beds_null,
    COUNT(*) FILTER (WHERE patients_request IS NULL) AS patients_request_null,
    COUNT(*) FILTER (WHERE patients_admitted IS NULL) AS patients_admitted_null,
    COUNT(*) FILTER (WHERE patients_refused IS NULL) AS patients_refused_null,
    COUNT(*) FILTER (WHERE patient_satisfaction IS NULL) AS patient_satisfaction_null,
    COUNT(*) FILTER (WHERE staff_morale IS NULL) AS staff_role_null,
    COUNT(*) FILTER (WHERE event IS NULL) AS event_null
FROM services_weekly;

-- Check for NULL values in the staff table
SELECT
    COUNT(*) FILTER (WHERE staff_id IS NULL) AS staff_id_null,
    COUNT(*) FILTER (WHERE staff_name IS NULL) AS staff_name_null,
    COUNT(*) FILTER (WHERE staff_role IS NULL) AS staff_role_null,
    COUNT(*) FILTER (WHERE service IS NULL) AS services_null
FROM staff;

-- Check for NULL values in the staff_schedule table
SELECT
    COUNT(*) FILTER (WHERE week_no IS NULL) AS week_no_null,
    COUNT(*) FILTER (WHERE staff_id IS NULL) AS staff_id_null,
    COUNT(*) FILTER (WHERE staff_name IS NULL) AS staff_name_null,
    COUNT(*) FILTER (WHERE staff_role IS NULL) AS staff_role_null,
    COUNT(*) FILTER (WHERE service IS NULL) AS service_null,
    COUNT(*) FILTER (WHERE present IS NULL) AS present_null
FROM staff_schedule;

-- Conclusion: All tables contain 0 null values.
-- Note: The reason behind this is that this collection of synthetic hospital datasets is designed to simulate real-world operations for a
-- medium-sized hospital, focusing on staffing, patient admissions, and bed allocation among services.
-- The data allows for exploration and analysis of hospital resource distribution, including personnel
-- deployment, patient demand, and service-level performance.