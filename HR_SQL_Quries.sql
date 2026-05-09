-- STEP 1 : CREATE DATABASE
CREATE DATABASE hr_project;

-- STEP 2 : USE DATABASE:
USE hr_project;

-- STEP 3 : CREATE TABLE
CREATE TABLE hr_data (

    Age VARCHAR(50),
    Attrition VARCHAR(50),
    BusinessTravel VARCHAR(100),
    DailyRate VARCHAR(50),
    Department VARCHAR(100),
    Education VARCHAR(50),
    EducationField VARCHAR(100),
    EmployeeCount VARCHAR(50),
    EmployeeNumber VARCHAR(50),
    EnvironmentSatisfaction VARCHAR(50),
    Gender VARCHAR(50),
    HourlyRate VARCHAR(50),
    JobRole VARCHAR(100),
    JobSatisfaction VARCHAR(50),
    MaritalStatus VARCHAR(50),
    MonthlyIncome VARCHAR(50),
    MonthlyRate VARCHAR(50),
    NumCompaniesWorked VARCHAR(50),
    OverTime VARCHAR(50),
    PercentSalaryHike VARCHAR(50),
    PerformanceRating VARCHAR(50),
    RelationshipSatisfaction VARCHAR(50),
    StandardHours VARCHAR(50),
    StockOptionLevel VARCHAR(50),
    TrainingTimesLastYear VARCHAR(50),
    WorkLifeBalance VARCHAR(50),
    YearsAtCompany VARCHAR(50),
    YearsInCurrentRole VARCHAR(50),
    YearsSinceLastPromotion VARCHAR(50),
    YearsWithCurrManager VARCHAR(50),
    DistanceFromoffice VARCHAR(100),
    JobInvolvement VARCHAR(100),
    `Job Level` VARCHAR(100),
    `Total Working Years` VARCHAR(100),
    Retirement VARCHAR(100),
    `Promotion status` VARCHAR(100),
    `Job satisfaction` VARCHAR(100),
    `Performance Rating` VARCHAR(100)

);

-- STEP 4 : CHECK TABLE
SHOW TABLES;
DESC hr_data;

-- STEP 5: VERIFY IMPORTED DATA:
SELECT * 
FROM hr_data
LIMIT 10;

-- STEP 6 : DATA QUALITY CHECK:
SELECT 
    COUNT(*) AS total_rows,
    COUNT(Age) AS age_not_null,
    COUNT(Gender) AS gender_not_null
FROM hr_data;

-- STEP 7 : CORE KPI ANALYSIS:
-- Total Employees:
SELECT 
COUNT(*) AS total_employees
FROM hr_data;

-- Attrition Count:
SELECT 
COUNT(*) AS attrition_count
FROM hr_data
WHERE Attrition = 'Yes';

-- Attrition Rate:
SELECT 
ROUND(
COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
* 100.0 / COUNT(*),
2
) AS attrition_rate
FROM hr_data;

-- Active Employees:
SELECT 
COUNT(*) 
- COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
AS active_employees
FROM hr_data;

-- Average Age:
SELECT 
ROUND(AVG(CAST(Age AS SIGNED)),2) AS avg_age
FROM hr_data;

-- STEP 8 : WORKFORCE DISTRIBUTION
-- Gender Distribution:
SELECT 
Gender,
COUNT(*) AS total
FROM hr_data
GROUP BY Gender
ORDER BY total DESC;

-- Department Distribution:
SELECT 
Department,
COUNT(*) AS total
FROM hr_data
GROUP BY Department
ORDER BY total DESC;

-- Job Role Distribution:
SELECT 
JobRole,
COUNT(*) AS total
FROM hr_data
GROUP BY JobRole
ORDER BY total DESC;

-- STEP 9 : ATTRITION ANALYSIS
-- Attrition by Gender:
SELECT 
Gender,
COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
AS attrition_count
FROM hr_data
GROUP BY Gender;

-- Attrition by Department:
SELECT 
Department,
COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
AS attrition_count
FROM hr_data
GROUP BY Department
ORDER BY attrition_count DESC;

-- Attrition Rate by Department:
SELECT 
Department,
COUNT(*) AS total_employees,
COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
AS attrition_count,
ROUND(
COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
* 100.0 / COUNT(*),
2
) AS attrition_rate
FROM hr_data
GROUP BY Department
ORDER BY attrition_rate DESC;

-- STEP 10 : DRIVER ANALYSIS:
-- Business Travel Impact:
SELECT 
BusinessTravel,
COUNT(*) AS total,
COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
AS attrition_count
FROM hr_data
GROUP BY BusinessTravel;

-- Overtime Impact:
SELECT 
OverTime,
COUNT(*) AS total,
COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
AS attrition_count,
ROUND(
COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
* 100.0 / COUNT(*),
2
) AS attrition_rate
FROM hr_data
GROUP BY OverTime;

-- Work Life Balance Impact:
SELECT 
WorkLifeBalance,
COUNT(*) AS total,
COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
AS attrition_count
FROM hr_data
GROUP BY WorkLifeBalance
ORDER BY CAST(WorkLifeBalance AS SIGNED);

-- Job Satisfaction Impact:
SELECT 
JobSatisfaction,
COUNT(*) AS total,
COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
AS attrition_count
FROM hr_data
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

-- STEP 11 : SALARY & EXPERIENCE ANALYSIS:
-- Average Salary by Role:
SELECT 
JobRole,
ROUND(AVG(CAST(MonthlyIncome AS SIGNED)),2)
AS avg_salary
FROM hr_data
GROUP BY JobRole
ORDER BY avg_salary DESC;

-- Experience vs Salary:
SELECT 
`Total Working Years`,
ROUND(AVG(CAST(MonthlyIncome AS SIGNED)),2)
AS avg_salary
FROM hr_data
GROUP BY `Total Working Years`
ORDER BY CAST(`Total Working Years` AS SIGNED);

-- STEP 12 : PROMOTION & RETENTION:
-- Promotion Due Employees:
SELECT 
JobRole,
COUNT(*) AS promotion_due
FROM hr_data
WHERE CAST(YearsSinceLastPromotion AS SIGNED) >= 5
GROUP BY JobRole;

-- Retirement Risk:
SELECT 
COUNT(*) AS retirement_count
FROM hr_data
WHERE CAST(Age AS SIGNED) >= 58;


-- STEP 13 : HIGH RISK EMPLOYEES:
SELECT *
FROM hr_data
WHERE OverTime='Yes'
AND CAST(WorkLifeBalance AS SIGNED) <= 2;


-- STEP 14 : RISK SEGMENTATION:
SELECT 
CASE 
WHEN OverTime='Yes'
AND CAST(WorkLifeBalance AS SIGNED) <= 2
THEN 'High Risk'
WHEN CAST(JobSatisfaction AS SIGNED) <= 2
THEN 'Medium Risk'
ELSE 'Low Risk'
END AS risk_level,
COUNT(*) AS total_employees
FROM hr_data
GROUP BY risk_level;


-- STEP 15 : ADVANCED ANALYSIS:
-- Department Ranking by Attrition:
SELECT 
Department,
COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
AS attrition_count,
RANK() OVER (
ORDER BY COUNT(
CASE WHEN Attrition='Yes' THEN 1 END
) DESC
) AS dept_rank
FROM hr_data
GROUP BY Department;