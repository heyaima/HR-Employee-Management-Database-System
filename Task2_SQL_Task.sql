USE EmployeeDB;
GO

CREATE TABLE Projects
(
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL
);

CREATE TABLE EmployeeProjects
(
    EmployeeID INT,
    ProjectID INT,

    PRIMARY KEY (EmployeeID, ProjectID),

    FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID),

    FOREIGN KEY (ProjectID)
        REFERENCES Projects(ProjectID)
);

INSERT INTO Projects
VALUES
(1,'Website Development'),
(2,'Mobile App'),
(3,'Payroll System'),
(4,'CRM System'),
(5,'Marketing Campaign'),
(6,'Cloud Migration'),
(7,'Cyber Security'),
(8,'Data Analytics'),
(9,'AI Chatbot'),
(10,'ERP System');

INSERT INTO EmployeeProjects
VALUES
(101,1),
(101,2),
(102,5),
(103,3),
(104,5),
(105,2),
(106,4),
(107,7),
(108,8),
(109,10),
(110,3),
(111,6),
(112,2),
(113,8),
(114,10);

--------------------------------------------------------------------------------------------
--Display Employee Name, Department Name, and Project Name

SELECT
    E.EmployeeName,
    D.DepartmentName,
    P.ProjectName
FROM Employees E
INNER JOIN Departments D
ON E.DepartmentID = D.DepartmentID
INNER JOIN EmployeeProjects EP
ON E.EmployeeID = EP.EmployeeID
INNER JOIN Projects P
ON EP.ProjectID = P.ProjectID;

---------------------------------------------------------------------------------------------
--Employees who are not assigned to any project

SELECT
    EmployeeName
FROM Employees
WHERE EmployeeID NOT IN
(
    SELECT EmployeeID
    FROM EmployeeProjects
);

---------------------------------------------------------------------------------------------
--Number of employees assigned to each project

SELECT
    P.ProjectName,
    COUNT(EP.EmployeeID) AS TotalEmployees
FROM Projects P
LEFT JOIN EmployeeProjects EP
ON P.ProjectID = EP.ProjectID
GROUP BY P.ProjectName;

---------------------------------------------------------------------------------------------
--Project with the highest number of employees

SELECT TOP 1
    P.ProjectName,
    COUNT(EP.EmployeeID) AS TotalEmployees
FROM Projects P
JOIN EmployeeProjects EP
ON P.ProjectID = EP.ProjectID
GROUP BY P.ProjectName
ORDER BY TotalEmployees DESC;

---------------------------------------------------------------------------------------------
--Employees working on more than one project

SELECT
    E.EmployeeName,
    COUNT(EP.ProjectID) AS TotalProjects
FROM Employees E
JOIN EmployeeProjects EP
ON E.EmployeeID = EP.EmployeeID
GROUP BY E.EmployeeName
HAVING COUNT(EP.ProjectID) > 1;

---------------------------------------------------------------------------------------------

SELECT
    P.ProjectName
FROM Projects P
LEFT JOIN EmployeeProjects EP
ON P.ProjectID = EP.ProjectID
WHERE EP.EmployeeID IS NULL;

---------------------------------------------------------------------------------------------


CREATE VIEW EmployeeProjectDetails
AS
SELECT
    E.EmployeeName,
    D.DepartmentName,
    P.ProjectName
FROM Employees E
JOIN Departments D
ON E.DepartmentID = D.DepartmentID
JOIN EmployeeProjects EP
ON E.EmployeeID = EP.EmployeeID
JOIN Projects P
ON EP.ProjectID = P.ProjectID;

SELECT *
FROM EmployeeProjectDetails;