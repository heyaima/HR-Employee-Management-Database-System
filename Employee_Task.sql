CREATE DATABASE EmployeeDB;

CREATE TABLE Departments
(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL
);
CREATE TABLE Employees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100) NOT NULL,
    Salary DECIMAL(10,2),
    DepartmentID INT,

    FOREIGN KEY (DepartmentID)
    REFERENCES Departments(DepartmentID)
);
INSERT INTO Departments
VALUES
(1,'Human Resources'),
(2,'Information Technology'),
(3,'Finance'),
(4,'Marketing'),
(5,'Sales');
INSERT INTO Employees
VALUES
(101,'Ali Khan',65000,2),
(102,'Sara Ahmed',72000,1),
(103,'Ahmed Raza',58000,3),
(104,'Fatima Noor',48000,4),
(105,'Usman Tariq',81000,2),
(106,'Ayesha Malik',56000,5),
(107,'Bilal Hussain',92000,2),
(108,'Hina Shah',61000,1),
(109,'Hamza Ali',70000,5),
(110,'Zain Abbas',55000,3),
(111,'Mariam Khan',67000,4),
(112,'Omar Siddique',83000,2),
(113,'Laiba Aslam',60000,3),
(114,'Danish Iqbal',75000,5),
(115,'Noor Fatima',50000,1);


--------------------------------------------------------------------------------------------

--DISPLAY EMPLOYEE NAME AND DEPARTMENT NAME
SELECT DepartmentName,EmployeeName
FROM Departments
JOIN Employees 
ON Departments.DepartmentID= Employees.DepartmentID

--------------------------------------------------------------------------------------------

--COUNT THE NUMBER OF EMPLOYEES IN EACH DEPARTMENT
SELECT
    DepartmentName,
    COUNT(EmployeeID) AS TotalEmployees
FROM Employees
INNER JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID
GROUP BY DepartmentName;

--------------------------------------------------------------------------------------------
--RETRIVE TOP 3 HIGHEST PAID EMPLOYEE
SELECT TOP 3
    EmployeeName,
    Salary
FROM Employees
ORDER BY Salary DESC;

--------------------------------------------------------------------------------------------

--CALCULATE THE AVERGE SALARY FOR EACH DEPARTMENT
SELECT
    DepartmentName,
    AVG(Salary) AS AverageSalary
FROM Employees
INNER JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID
GROUP BY DepartmentName;

--------------------------------------------------------------------------------------------

--EMPLOYEE WHOSE SALARY IN GREATER THAN AVG COMPANY SALARY
SELECT
    EmployeeName,
    Salary
FROM Employees
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM Employees
);

--------------------------------------------------------------------------------------------

--List Employees by Salary (Highest to Lowest)
SELECT
    EmployeeName,
    Salary
FROM Employees
ORDER BY Salary DESC;

--------------------------------------------------------------------------------------------

CREATE VIEW EmployeeDetails
AS
SELECT
    Employees.EmployeeName,
    Departments.DepartmentName,
    Employees.Salary
FROM Employees
INNER JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID;

SELECT *
FROM EmployeeDetails;