CREATE TABLE Department (
    Department_ID NUMBER PRIMARY KEY,
    Department_Name VARCHAR2(100) NOT NULL,
    Manager_ID NUMBER
);
CREATE TABLE Job (
    Job_ID NUMBER PRIMARY KEY,
    Job_Title VARCHAR2(100) NOT NULL,
    Min_Salary NUMBER CHECK (Min_Salary >= 0),
    Max_Salary NUMBER,
    CONSTRAINT chk_salary_range CHECK (Max_Salary >= Min_Salary)
);
CREATE TABLE Employee (
    Employee_ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Department_ID NUMBER,
    Job_ID NUMBER,
    Hire_Date DATE,
    Salary NUMBER NOT NULL,
    FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID),
    FOREIGN KEY (Job_ID) REFERENCES Job(Job_ID)

CREATE TABLE Payroll (
    Payroll_ID NUMBER PRIMARY KEY,
    Employee_ID NUMBER NOT NULL,
    Basic_Salary NUMBER NOT NULL,
    Overtime NUMBER DEFAULT 0,
    E_T_F NUMBER GENERATED ALWAYS AS (Basic_Salary * 0.08) VIRTUAL, 
    Payment_Date DATE,
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
);



INSERT INTO Department (Department_ID, Department_Name, Manager_ID) 
VALUES (1, 'Human Resources', NULL);

INSERT INTO Department (Department_ID, Department_Name, Manager_ID) 
VALUES (2, 'Finance', NULL);

INSERT INTO Department (Department_ID, Department_Name, Manager_ID) 
VALUES (3, 'IT', NULL);



INSERT INTO Job (Job_ID, Job_Title, Min_Salary, Max_Salary) 
VALUES (1, 'Manager', 50000, 100000);

INSERT INTO Job (Job_ID, Job_Title, Min_Salary, Max_Salary) 
VALUES (2, 'Analyst', 30000, 70000);

INSERT INTO Job (Job_ID, Job_Title, Min_Salary, Max_Salary) 
VALUES (3, 'Developer', 40000, 80000);


INSERT INTO Employee (Employee_ID, Name, Department_ID, Job_ID, Hire_Date, Salary) 
VALUES (1, 'Buddhika Prasad', 1, 1, TO_DATE('2023-01-15', 'YYYY-MM-DD'), 75000);

INSERT INTO Employee (Employee_ID, Name, Department_ID, Job_ID, Hire_Date, Salary) 
VALUES (2, 'Chamindu Perea', 2, 2, TO_DATE('2023-06-12', 'YYYY-MM-DD'), 45000);

INSERT INTO Employee (Employee_ID, Name, Department_ID, Job_ID, Hire_Date, Salary) 
VALUES (3, 'Bandara Bandara', 1, 3, TO_DATE('2024-02-10', 'YYYY-MM-DD'), 55000);

INSERT INTO Employee (Employee_ID, Name, Department_ID, Job_ID, Hire_Date, Salary) 
VALUES (4, 'Sadun Nuwan', 3, 2, TO_DATE('2024-03-05', 'YYYY-MM-DD'), 60000);


INSERT INTO Payroll (Payroll_ID, Employee_ID, Salary, Payment_Date) 
VALUES (1, 1, 75000, TO_DATE('2024-01-31', 'YYYY-MM-DD'));

INSERT INTO Payroll (Payroll_ID, Employee_ID, Salary, Payment_Date) 
VALUES (2, 2, 45000, TO_DATE('2024-02-28', 'YYYY-MM-DD'));

INSERT INTO Payroll (Payroll_ID, Employee_ID, Salary, Payment_Date) 
VALUES (3, 3, 55000, TO_DATE('2024-03-31', 'YYYY-MM-DD'));

INSERT INTO Payroll (Payroll_ID, Employee_ID, Salary, Payment_Date) 
VALUES (4, 4, 60000, TO_DATE('2024-04-30', 'YYYY-MM-DD'));

INSERT INTO Payroll (Payroll_ID, Employee_ID, Basic_Salary, Overtime, Allowance, Payment_Date) 
VALUES (1, 1, 75000, 5000, 1500, TO_DATE('2024-01-31', 'YYYY-MM-DD'));

INSERT INTO Payroll (Payroll_ID, Employee_ID, Basic_Salary, Overtime, Allowance, Payment_Date) 
VALUES (2, 2, 45000, 3000, 1200, TO_DATE('2024-02-28', 'YYYY-MM-DD'));

INSERT INTO Payroll (Payroll_ID, Employee_ID, Basic_Salary, Overtime, Allowance, Payment_Date) 
VALUES (3, 3, 55000, 2000, 1300, TO_DATE('2024-03-31', 'YYYY-MM-DD'));

INSERT INTO Payroll (Payroll_ID, Employee_ID, Basic_Salary, Overtime, Allowance, Payment_Date) 
VALUES (4, 4, 60000, 2500, 1400, TO_DATE('2024-04-30', 'YYYY-MM-DD'));

UPDATE Employee 
SET Salary = 65000 
WHERE Employee_ID = 2;

DELETE FROM Employee 
WHERE Employee_ID = 2;


--avarage salary by department
CREATE OR REPLACE PROCEDURE avg_salary_by_department AS
    CURSOR dept_avg_salary_cur IS
        SELECT d.Department_Name, AVG(e.Salary) AS Avg_Salary
        FROM Department d
        JOIN Employee e ON d.Department_ID = e.Department_ID
        GROUP BY d.Department_Name;
    v_department_name Department.Department_Name%TYPE;
    v_avg_salary NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Average Salary by Department:');
    OPEN dept_avg_salary_cur;
    LOOP
        FETCH dept_avg_salary_cur INTO v_department_name, v_avg_salary;
        EXIT WHEN dept_avg_salary_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Department: ' || v_department_name || ' | Avg Salary: ' || v_avg_salary);
    END LOOP;
    CLOSE dept_avg_salary_cur;
END;
/


--employee count by job role
CREATE OR REPLACE PROCEDURE employee_count_by_job_role AS
    CURSOR job_count_cur IS
        SELECT j.Job_Title, COUNT(e.Employee_ID) AS Employee_Count
        FROM Job j
        JOIN Employee e ON j.Job_ID = e.Job_ID
        GROUP BY j.Job_Title;
    v_job_title Job.Job_Title%TYPE;
    v_employee_count NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Employee Count by Job Role:');
    OPEN job_count_cur;
    LOOP
        FETCH job_count_cur INTO v_job_title, v_employee_count;
        EXIT WHEN job_count_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Job Title: ' || v_job_title || ' | Employee Count: ' || v_employee_count);
    END LOOP;
    CLOSE job_count_cur;
END;
/


--Employees Hired in the Last Year
CREATE OR REPLACE PROCEDURE employees_hired_last_year AS
    CURSOR recent_hires_cur IS
        SELECT Name, Hire_Date 
        FROM Employee 
        WHERE Hire_Date >= ADD_MONTHS(SYSDATE, -12);
    v_name Employee.Name%TYPE;
    v_hire_date Employee.Hire_Date%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Employees Hired in the Last Year:');
    OPEN recent_hires_cur;
    LOOP
        FETCH recent_hires_cur INTO v_name, v_hire_date;
        EXIT WHEN recent_hires_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Name: ' || v_name || ' | Hire Date: ' || v_hire_date);
    END LOOP;
    CLOSE recent_hires_cur;
END;
/

--Highest and Lowest Salary in Each Department
CREATE OR REPLACE PROCEDURE highest_lowest_salary_by_department AS
    CURSOR dept_salary_cur IS
        SELECT d.Department_Name, 
               MAX(e.Salary) AS Highest_Salary, 
               MIN(e.Salary) AS Lowest_Salary
        FROM Department d
        JOIN Employee e ON d.Department_ID = e.Department_ID
        GROUP BY d.Department_Name;
    v_department_name Department.Department_Name%TYPE;
    v_highest_salary NUMBER;
    v_lowest_salary NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Highest and Lowest Salary by Department:');
    OPEN dept_salary_cur;
    LOOP
        FETCH dept_salary_cur INTO v_department_name, v_highest_salary, v_lowest_salary;
        EXIT WHEN dept_salary_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Department: ' || v_department_name || 
                             ' | Highest Salary: ' || v_highest_salary || 
                             ' | Lowest Salary: ' || v_lowest_salary);
    END LOOP;
    CLOSE dept_salary_cur;
END;
/


--Payroll Report with Recent Payments
CREATE OR REPLACE PROCEDURE recent_payroll_report AS
    CURSOR payroll_cur IS
        SELECT p.Payroll_ID, e.Name, p.Salary, p.Payment_Date
        FROM Payroll p
        JOIN Employee e ON p.Employee_ID = e.Employee_ID
        WHERE p.Payment_Date >= ADD_MONTHS(SYSDATE, -1); -- recent payments within the last month
    v_payroll_id Payroll.Payroll_ID%TYPE;
    v_name Employee.Name%TYPE;
    v_salary Payroll.Salary%TYPE;
    v_payment_date Payroll.Payment_Date%TYPE;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('Recent Payroll Payments:');
    OPEN payroll_cur;
    LOOP
        FETCH payroll_cur INTO v_payroll_id, v_name, v_salary, v_payment_date;
        EXIT WHEN payroll_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Payroll ID: ' || v_payroll_id || ' | Name: ' || v_name ||
                             ' | Salary: ' || v_salary || ' | Payment Date: ' || v_payment_date);
    END LOOP;
    CLOSE payroll_cur;
END;
/


BEGIN
    avg_salary_by_department;
END;
/
BEGIN
    employee_count_by_job_role;
END;
/
BEGIN
    employees_hired_last_year;
END;
/
BEGIN
    highest_lowest_salary_by_department;
END;
/
BEGIN
    recent_payroll_report;
END;
/

DROP TABLE Payroll PURGE;

CREATE OR REPLACE PROCEDURE generate_payslip (p_employee_id NUMBER, p_month NUMBER, p_year NUMBER) AS
    v_name Employee.Name%TYPE;
    v_department_name Department.Department_Name%TYPE;
    v_job_title Job.Job_Title%TYPE;
    v_hire_date Employee.Hire_Date%TYPE;
    v_basic_salary Payroll.Basic_Salary%TYPE;
    v_overtime Payroll.Overtime%TYPE;
    v_allowance Payroll.Allowance%TYPE;
    v_e_t_f Payroll.E_T_F%TYPE;
    v_total_earnings NUMBER;
    v_total_deductions NUMBER;
    v_net_pay NUMBER;
BEGIN
    -- Get Employee, Job, and Department information
    SELECT e.Name, d.Department_Name, j.Job_Title, e.Hire_Date
    INTO v_name, v_department_name, v_job_title, v_hire_date
    FROM Employee e
    JOIN Department d ON e.Department_ID = d.Department_ID
    JOIN Job j ON e.Job_ID = j.Job_ID
    WHERE e.Employee_ID = p_employee_id;

    -- Get Payroll Information
    SELECT Basic_Salary, Overtime, Allowance, E_T_F
    INTO v_basic_salary, v_overtime, v_allowance, v_e_t_f
    FROM Payroll
    WHERE Employee_ID = p_employee_id
    AND EXTRACT(MONTH FROM Payment_Date) = p_month
    AND EXTRACT(YEAR FROM Payment_Date) = p_year;

    -- Calculate Totals
    v_total_earnings := v_basic_salary + v_overtime + v_allowance;
    v_total_deductions := v_e_t_f;
    v_net_pay := v_total_earnings - v_total_deductions;

    -- Print Payslip
    DBMS_OUTPUT.PUT_LINE('Payslip');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Employee Name   : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Department      : ' || v_department_name);
    DBMS_OUTPUT.PUT_LINE('Designation     : ' || v_job_title);
    DBMS_OUTPUT.PUT_LINE('Hire Date       : ' || TO_CHAR(v_hire_date, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Pay Period      : ' || TO_CHAR(TO_DATE(p_month || '-' || p_year, 'MM-YYYY'), 'Month YYYY'));
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Earnings:');
    DBMS_OUTPUT.PUT_LINE('  Basic Salary  : ' || v_basic_salary);
    DBMS_OUTPUT.PUT_LINE('  Overtime      : ' || v_overtime);
    DBMS_OUTPUT.PUT_LINE('  Allowance     : ' || v_allowance);
    DBMS_OUTPUT.PUT_LINE('Total Earnings  : ' || v_total_earnings);
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Deductions:');
    DBMS_OUTPUT.PUT_LINE('  E.T.F (8%)    : ' || v_e_t_f);
    DBMS_OUTPUT.PUT_LINE('Total Deductions: ' || v_total_deductions);
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Net Pay         : ' || v_net_pay);
END;
/

-- Test the procedure for an employee, for example, for January 2024
BEGIN
    generate_payslip(1, 1, 2024);
END;
/
-- Drop old Payroll table if needed
DROP TABLE Payroll PURGE;

-- Re-create Payroll table with dynamic fields
CREATE TABLE Payroll (
    Payroll_ID NUMBER PRIMARY KEY,
    Employee_ID NUMBER NOT NULL,
    Basic_Salary NUMBER NOT NULL,
    Overtime NUMBER DEFAULT 0,
    Allowance NUMBER DEFAULT 0, 
    E_T_F NUMBER GENERATED ALWAYS AS (Basic_Salary * 0.08) VIRTUAL, 
    Payment_Date DATE,
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
);

-- Sample insert data with dynamic overtime and allowance inputs
INSERT INTO Payroll (Payroll_ID, Employee_ID, Basic_Salary, Overtime, Allowance, Payment_Date) 
VALUES (1, 1, 75000, 5000, 1500, TO_DATE('2024-01-31', 'YYYY-MM-DD'));

INSERT INTO Payroll (Payroll_ID, Employee_ID, Basic_Salary, Overtime, Allowance, Payment_Date) 
VALUES (2, 2, 45000, 3000, 1200, TO_DATE('2024-02-28', 'YYYY-MM-DD'));

INSERT INTO Payroll (Payroll_ID, Employee_ID, Basic_Salary, Overtime, Allowance, Payment_Date) 
VALUES (3, 3, 55000, 2000, 1300, TO_DATE('2024-03-31', 'YYYY-MM-DD'));

INSERT INTO Payroll (Payroll_ID, Employee_ID, Basic_Salary, Overtime, Allowance, Payment_Date) 
VALUES (4, 4, 60000, 2500, 1400, TO_DATE('2024-04-30', 'YYYY-MM-DD'));


-- Updated Payslip Procedure
CREATE OR REPLACE PROCEDURE generate_payslip (p_employee_id NUMBER, p_month NUMBER, p_year NUMBER) AS
    v_name Employee.Name%TYPE;
    v_department_name Department.Department_Name%TYPE;
    v_job_title Job.Job_Title%TYPE;
    v_hire_date Employee.Hire_Date%TYPE;
    v_basic_salary Payroll.Basic_Salary%TYPE;
    v_overtime Payroll.Overtime%TYPE;
    v_allowance Payroll.Allowance%TYPE;
    v_e_t_f Payroll.E_T_F%TYPE;
    v_total_earnings NUMBER;
    v_total_deductions NUMBER;
    v_net_pay NUMBER;
BEGIN
    -- Get Employee, Job, and Department information
    SELECT e.Name, d.Department_Name, j.Job_Title, e.Hire_Date
    INTO v_name, v_department_name, v_job_title, v_hire_date
    FROM Employee e
    JOIN Department d ON e.Department_ID = d.Department_ID
    JOIN Job j ON e.Job_ID = j.Job_ID
    WHERE e.Employee_ID = p_employee_id;

    -- Get Payroll Information
    SELECT Basic_Salary, Overtime, Allowance, E_T_F
    INTO v_basic_salary, v_overtime, v_allowance, v_e_t_f
    FROM Payroll
    WHERE Employee_ID = p_employee_id
    AND EXTRACT(MONTH FROM Payment_Date) = p_month
    AND EXTRACT(YEAR FROM Payment_Date) = p_year;

    -- Calculate Totals
    v_total_earnings := v_basic_salary + v_overtime + v_allowance;
    v_total_deductions := v_e_t_f;
    v_net_pay := v_total_earnings - v_total_deductions;

    -- Print Payslip
    DBMS_OUTPUT.PUT_LINE('Payslip');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Employee Name   : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Department      : ' || v_department_name);
    DBMS_OUTPUT.PUT_LINE('Designation     : ' || v_job_title);
    DBMS_OUTPUT.PUT_LINE('Hire Date       : ' || TO_CHAR(v_hire_date, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Pay Period      : ' || TO_CHAR(TO_DATE(p_month || '-' || p_year, 'MM-YYYY'), 'Month YYYY'));
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Earnings:');
    DBMS_OUTPUT.PUT_LINE('  Basic Salary  : ' || v_basic_salary);
    DBMS_OUTPUT.PUT_LINE('  Overtime      : ' || v_overtime);
    DBMS_OUTPUT.PUT_LINE('  Allowance     : ' || v_allowance);
    DBMS_OUTPUT.PUT_LINE('Total Earnings  : ' || v_total_earnings);
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Deductions:');
    DBMS_OUTPUT.PUT_LINE('  E.T.F (8%)    : ' || v_e_t_f);
    DBMS_OUTPUT.PUT_LINE('Total Deductions: ' || v_total_deductions);
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Net Pay         : ' || v_net_pay);
END;
/

-- Test the procedure for an employee, for example, for January 2024
BEGIN
    generate_payslip(1, 1, 2024);
END;
/
-- Procedure to generate a payroll report with recent payments
CREATE OR REPLACE PROCEDURE create_payroll_report_with_recent_payments AS
    CURSOR payroll_cur IS
        SELECT p.Payroll_ID, e.Name, d.Department_Name, j.Job_Title, p.Basic_Salary, 
               p.Overtime, p.Allowance, p.E_T_F, p.Payment_Date
        FROM Payroll p
        JOIN Employee e ON p.Employee_ID = e.Employee_ID
        JOIN Department d ON e.Department_ID = d.Department_ID
        JOIN Job j ON e.Job_ID = j.Job_ID
        WHERE p.Payment_Date >= ADD_MONTHS(SYSDATE, -1);

    v_payroll_id Payroll.Payroll_ID%TYPE;
    v_name Employee.Name%TYPE;
    v_department_name Department.Department_Name%TYPE;
    v_job_title Job.Job_Title%TYPE;
    v_basic_salary Payroll.Basic_Salary%TYPE;
    v_overtime Payroll.Overtime%TYPE;
    v_allowance Payroll.Allowance%TYPE;
    v_e_t_f Payroll.E_T_F%TYPE;
    v_total_earnings NUMBER;
    v_net_pay NUMBER;
    v_payment_date Payroll.Payment_Date%TYPE;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('Recent Payroll Payments Report');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Payroll ID | Employee Name | Department | Job Title | Basic Salary | Overtime | Allowance | E.T.F | Net Pay | Payment Date');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------------------------------------------');
    
    OPEN payroll_cur;
    LOOP
        FETCH payroll_cur INTO v_payroll_id, v_name, v_department_name, v_job_title, v_basic_salary, v_overtime, v_allowance, v_e_t_f, v_payment_date;
        EXIT WHEN payroll_cur%NOTFOUND;
        
        -- Calculate total earnings and net pay
        v_total_earnings := v_basic_salary + v_overtime + v_allowance;
        v_net_pay := v_total_earnings - v_e_t_f;
        
        DBMS_OUTPUT.PUT_LINE(v_payroll_id || ' | ' || v_name || ' | ' || v_department_name || ' | ' || v_job_title || ' | ' ||
                             v_basic_salary || ' | ' || v_overtime || ' | ' || v_allowance || ' | ' || v_e_t_f || ' | ' ||
                             v_net_pay || ' | ' || TO_CHAR(v_payment_date, 'YYYY-MM-DD'));
    END LOOP;
    CLOSE payroll_cur;
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------------------------------------------');
END;
/

-- Execute the procedure to view recent payments report
BEGIN
    create_payroll_report_with_recent_payments;
END;
/
