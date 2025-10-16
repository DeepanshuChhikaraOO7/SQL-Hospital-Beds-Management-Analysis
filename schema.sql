-- Drop existing tables to ensure a clean slate
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS servies_weekly;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS staff_schedule;

-- Create the patients table to store patient information
CREATE TABLE patients(
    patient_id TEXT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    arrival_date DATE,
    departure_date DATE,
    service VARCHAR(50),
    satisfaction INT
);

-- Create the servies_weekly table to store weekly service metrics
CREATE TABLE servies_weekly(
    week_no INT,
    month_no INT,
    service VARCHAR(50),
    available_beds INT,
    patients_request INT,
    patients_admitted INT,
    patients_refused INT,
    patient_satisfaction INT,
    staff_morale INT,
    event VARCHAR(50)
);

-- Create the staff table to store staff information
CREATE TABLE staff(
    staff_id TEXT PRIMARY KEY,
    staff_name VARCHAR(50),
    staff_role VARCHAR(50),
    service VARCHAR(50)
);

-- Create the staff_schedule table to track weekly staff presence
CREATE TABLE staff_schedule(
    week_no INT,
    staff_id TEXT,
    staff_name VARCHAR(50),
    staff_role VARCHAR(50),
    service VARCHAR(50),
    present INT
);