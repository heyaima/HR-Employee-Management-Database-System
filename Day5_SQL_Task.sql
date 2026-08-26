--1. Retrieve employees from a specific department
CREATE PROCEDURE GetEmployeeByDepartment
   @DepartmentID INT
AS
BEGIN
     SELECT *
     FROM Employees
     WHERE DepartmentID= @DepartmentID
END;
GO

EXEC GetEmployeeByDepartment @DepartmentID = 1;

--------------------------------------------------------------------------------------------

--2. Retrieve employees whose salary is greater than a given amount
CREATE PROCEDURE GetEmployeesAboveSalary
    @Salary DECIMAL(10,2)
AS
BEGIN
    SELECT *
    FROM Employees
    WHERE Salary > @Salary;
END;
GO

EXEC GetEmployeesAboveSalary @Salary = 70000;

--------------------------------------------------------------------------------------------
--3. Insert a new employee

CREATE PROCEDURE AddEmployee
    @EmployeeID INT,
    @EmployeeName VARCHAR(100),
    @Salary DECIMAL(10,2),
    @DepartmentID INT,
    @JoiningDate DATE
AS
BEGIN
    INSERT INTO Employees
        (EmployeeID, EmployeeName, Salary, DepartmentID, JoiningDate)
    VALUES
        (@EmployeeID, @EmployeeName, @Salary, @DepartmentID, @JoiningDate);
END;
GO

EXEC AddEmployee
    @EmployeeID = 116,
    @EmployeeName = 'Aima Amjad',
    @Salary = 65000,
    @DepartmentID = 2,
    @JoiningDate = '2026-05-10';

SELECT *
FROM Employees
WHERE EmployeeID = 116;


--------------------------------------------------------------------------------------------
--4. Update an employee's salary

CREATE PROCEDURE UpdateEmployeeSalary
    @EmployeeID INT,
    @NewSalary DECIMAL(10,2)
AS
BEGIN
    UPDATE Employees
    SET Salary = @NewSalary
    WHERE EmployeeID = @EmployeeID;
END;
GO

EXEC UpdateEmployeeSalary
    @EmployeeID = 116,
    @NewSalary = 75000;

SELECT *
FROM Employees
WHERE EmployeeID = 116;


--------------------------------------------------------------------------------------------

--5. Delete an employee
CREATE PROCEDURE DeleteEmployee
    @EmployeeID INT
AS
BEGIN
    DELETE FROM Employees
    WHERE EmployeeID = @EmployeeID;
END;
GO

EXEC DeleteEmployee
    @EmployeeID = 116;

SELECT *
FROM Employees
WHERE EmployeeID = 116;