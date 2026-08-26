--Display all employees with a row number based on salary in descending order within each department.
SELECT
    EmployeeID,
    EmployeeName,
    DepartmentID,
    Salary,
    ROW_NUMBER() OVER
    (
        PARTITION BY DepartmentID
        ORDER BY Salary DESC
    ) AS RowNumber
FROM Employees;

--Display the rank of employees based on salary within each department.
SELECT
    EmployeeID,
    EmployeeName,
    DepartmentID,
    Salary,
    RANK() OVER
    (
        PARTITION BY DepartmentID
        ORDER BY Salary DESC
    ) AS SalaryRank
FROM Employees;

--Display the top 2 highest-paid employees from each department.
SELECT *
FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY DepartmentID
               ORDER BY Salary DESC
           ) AS RN
    FROM Employees
) AS E
WHERE RN <= 2;

--Find employees whose salary is above the average salary of their department.
SELECT *
FROM Employees E
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM Employees
    WHERE DepartmentID = E.DepartmentID
);

--Use a CTE to display employees earning more than 70,000.
WITH HighSalary AS
(
    SELECT *
    FROM Employees
    WHERE Salary > 70000
)

SELECT *
FROM HighSalary;

--Use a CTE to calculate the total salary paid by each department.
WITH DepartmentSalary AS
(
    SELECT
        DepartmentID,
        SUM(Salary) AS TotalSalary
    FROM Employees
    GROUP BY DepartmentID
)

SELECT *
FROM DepartmentSalary;

--Display the second highest-paid employee in each department.
SELECT *
FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY DepartmentID
               ORDER BY Salary DESC
           ) AS RN
    FROM Employees
) AS E
WHERE RN = 2;

--Find employees who have the same salary as another employee.
SELECT *
FROM Employees
WHERE Salary IN
(
    SELECT Salary
    FROM Employees
    GROUP BY Salary
    HAVING COUNT(*) > 1
);