ALTER TABLE Employees
ADD JoiningDate DATE;

UPDATE Employees SET JoiningDate = '2021-06-15' WHERE EmployeeID = 101;
UPDATE Employees SET JoiningDate = '2022-03-10' WHERE EmployeeID = 102;
UPDATE Employees SET JoiningDate = '2020-08-20' WHERE EmployeeID = 103;
UPDATE Employees SET JoiningDate = '2023-01-05' WHERE EmployeeID = 104;
UPDATE Employees SET JoiningDate = '2019-07-12' WHERE EmployeeID = 105;
UPDATE Employees SET JoiningDate = '2021-11-20' WHERE EmployeeID = 106;
UPDATE Employees SET JoiningDate = '2022-08-15' WHERE EmployeeID = 107;
UPDATE Employees SET JoiningDate = '2020-02-10' WHERE EmployeeID = 108;
UPDATE Employees SET JoiningDate = '2023-05-18' WHERE EmployeeID = 109;
UPDATE Employees SET JoiningDate = '2018-09-25' WHERE EmployeeID = 110;
UPDATE Employees SET JoiningDate = '2021-04-30' WHERE EmployeeID = 111;
UPDATE Employees SET JoiningDate = '2022-12-01' WHERE EmployeeID = 112;
UPDATE Employees SET JoiningDate = '2020-06-22' WHERE EmployeeID = 113;
UPDATE Employees SET JoiningDate = '2023-03-14' WHERE EmployeeID = 114;
UPDATE Employees SET JoiningDate = '2022-07-10' WHERE EmployeeID = 115;

SELECT *
FROM Employees;

--Create a Scalar Function that returns the annual salary of an employee based on their monthly salary.

CREATE FUNCTION dbo.fn_AnnualSalary
(
    @MonthlySalary DECIMAL(18,2)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    RETURN @MonthlySalary * 12;
END;
GO

SELECT dbo.fn_AnnualSalary(50000) AS AnnualSalary;

SELECT
    EmployeeName,
    Salary AS MonthlySalary,
    dbo.fn_AnnualSalary(Salary) AS AnnualSalary
FROM Employees;

--------------------------------------------------------------------------------------------

--Create a Scalar Function that calculates the service years of an employee using their joining date.

CREATE OR ALTER FUNCTION dbo.fn_ServiceYears

(
    @JoiningDate DATE
)

RETURNS INT
AS
BEGIN

    DECLARE @Years INT;
    SET @Years = DATEDIFF(YEAR, @JoiningDate, GETDATE());
    IF DATEADD(YEAR, @Years, @JoiningDate) > CAST(GETDATE() AS DATE)
        SET @Years = @Years - 1;
    RETURN @Years;

END;
GO

SELECT
    EmployeeName,
    dbo.fn_ServiceYears(JoiningDate) AS YearsOfService
FROM Employees;

--------------------------------------------------------------------------------------------

CREATE FUNCTION dbo.fn_EmployeesByDepartment
(
    @DepartmentID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        EmployeeID,
        EmployeeName,
        Salary,
        JoiningDate,
        DepartmentID
    FROM Employees
    WHERE DepartmentID = @DepartmentID
);

--Retrieve Employees From a Specific Department
SELECT *
FROM dbo.fn_EmployeesByDepartment(1);
GO

--Employees With Annual Salary Greater Than 1,000,000
SELECT
    EmployeeID,
    EmployeeName,
    Salary AS MonthlySalary,
    dbo.fn_AnnualSalary(Salary) AS AnnualSalary,
    DepartmentID
FROM Employees
WHERE dbo.fn_AnnualSalary(Salary) > 1000000;
GO

--Department With the Highest Average Annual Salary
SELECT TOP 1
    d.DepartmentID,
    d.DepartmentName,
    AVG(dbo.fn_AnnualSalary(e.Salary)) AS AverageAnnualSalary
FROM Departments d
INNER JOIN Employees e
    ON d.DepartmentID = e.DepartmentID
GROUP BY
    d.DepartmentID,
    d.DepartmentName
ORDER BY
    AverageAnnualSalary DESC;
GO
