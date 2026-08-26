
----------------------------------------------------------PART 1.1----------------------------------------------------
-- Create the Audit Table
CREATE TABLE EmployeeAudit
(
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    OperationType VARCHAR(10),
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    DepartmentID INT,
    OldSalary DECIMAL(10,2),
    NewSalary DECIMAL(10,2),
    JoiningDate DATE,
    AuditDate DATETIME DEFAULT GETDATE()
);
GO

----------------------------------------------------------PART 1.1----------------------------------------------------
--Create an AFTER INSERT trigger to record newly added employees.
CREATE OR ALTER TRIGGER trg_Employee_Insert
ON Employees
AFTER INSERT
AS
BEGIN
    INSERT INTO EmployeeAudit
    (
        OperationType,
        EmployeeID,
        EmployeeName,
        DepartmentID,
        NewSalary,
        JoiningDate
    )
    SELECT
        'INSERT',
        EmployeeID,
        EmployeeName,
        DepartmentID,
        Salary,
        JoiningDate
    FROM inserted;
END;
GO

INSERT INTO Employees
(EmployeeID, EmployeeName, Salary, DepartmentID, JoiningDate)
VALUES
(121, 'Arsalan', 65000, 1, '2026-08-10');

SELECT *
FROM EmployeeAudit;

-------------------------------------------------------PART 1.2----------------------------------------------------
--Create an AFTER UPDATE trigger to log salary changes including EmployeeID, Old Salary, New Salary and Updated Date.
CREATE OR ALTER TRIGGER trg_Employee_Salary_Update
ON Employees
AFTER UPDATE
AS
BEGIN
    INSERT INTO EmployeeAudit
    (
        OperationType,
        EmployeeID,
        OldSalary,
        NewSalary,
        AuditDate
    )
    SELECT
        'UPDATE',
        d.EmployeeID,
        d.Salary,
        i.Salary,
        GETDATE()
    FROM deleted d
    INNER JOIN inserted i
        ON d.EmployeeID = i.EmployeeID
    WHERE d.Salary <> i.Salary;
END;
GO

UPDATE Employees
SET Salary = 75000
WHERE EmployeeID = 121;

SELECT *
FROM EmployeeAudit
WHERE EmployeeID = 121;

------------------------------------------------------PART 1.3----------------------------------------------------
--Create an AFTER DELETE trigger to record deleted employee details.
CREATE OR ALTER TRIGGER trg_Employee_Delete
ON Employees
AFTER DELETE
AS
BEGIN
    INSERT INTO EmployeeAudit
    (
        OperationType,
        EmployeeID,
        EmployeeName,
        DepartmentID,
        OldSalary,
        JoiningDate,
        AuditDate
    )
    SELECT
        'DELETE',
        EmployeeID,
        EmployeeName,
        DepartmentID,
        Salary,
        JoiningDate,
        GETDATE()
    FROM deleted;
END;
GO

DELETE FROM Employees
WHERE EmployeeID = 121;

SELECT *
FROM EmployeeAudit
WHERE EmployeeID = 121;
------------------------------------------------------Part 2 — Transactions-----------------------------------------
--Write a transaction to update the salaries of multiple employees.

BEGIN TRY

    BEGIN TRANSACTION;

    UPDATE Employees
    SET Salary = Salary + 5000
    WHERE EmployeeID = 101;

    UPDATE Employees
    SET Salary = Salary + 5000
    WHERE EmployeeID = 102;

    UPDATE Employees
    SET Salary = Salary + 5000
    WHERE EmployeeID = 103;

    COMMIT TRANSACTION;

END TRY
BEGIN CATCH

    ROLLBACK TRANSACTION;

    PRINT 'Transaction failed. All changes have been rolled back.';
    PRINT ERROR_MESSAGE();

END CATCH;
GO

---------------------------------------------------Part 3 — Final Report-----------------------------------------------------
--3.1 Display all employee salary change history

SELECT
    EmployeeID,
    OldSalary,
    NewSalary,
    AuditDate
FROM EmployeeAudit
WHERE OperationType = 'UPDATE'
ORDER BY AuditDate DESC;

--3.2 Employees whose salaries were updated more than once
SELECT
    EmployeeID,
    COUNT(*) AS NumberOfSalaryUpdates
FROM EmployeeAudit
WHERE OperationType = 'UPDATE'
GROUP BY EmployeeID
HAVING COUNT(*) > 1;

--3.3 Latest salary update for each employee
WITH LatestSalaryUpdate AS
(
    SELECT
        EmployeeID,
        OldSalary,
        NewSalary,
        AuditDate,
        ROW_NUMBER() OVER
        (
            PARTITION BY EmployeeID
            ORDER BY AuditDate DESC
        ) AS RowNum
    FROM EmployeeAudit
    WHERE OperationType = 'UPDATE'
)
SELECT
    EmployeeID,
    OldSalary,
    NewSalary,
    AuditDate
FROM LatestSalaryUpdate
WHERE RowNum = 1;

--3.4 Count INSERT, UPDATE and DELETE operations
SELECT
    OperationType,
    COUNT(*) AS TotalOperations
FROM EmployeeAudit
GROUP BY OperationType;