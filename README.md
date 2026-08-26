
# HR Employee Management & Database System

A SQL Server-based employee management system designed to practice core and advanced database concepts — from schema design to automated auditing.

## Overview
This project models a company's HR structure with employees, departments, and project assignments, then layers in analytical queries, reusable procedures, and automated data-integrity tracking.

## Features
- **Relational Schema**: Departments, Employees, Projects, and a many-to-many `EmployeeProjects` junction table with enforced primary/foreign key constraints
- **Window Functions**: Used `ROW_NUMBER()` and `RANK()` to rank employees by salary within each department
- **Stored Procedures**: Parameterized procedures to retrieve employees by department (`GetEmployeeByDepartment`) or by salary threshold (`GetEmployeesAboveSalary`)
- **Triggers & Auditing**: An `AFTER INSERT` trigger automatically logs new employee records into a dedicated `EmployeeAudit` table, capturing old/new salary values and timestamps for traceability
- **Data Manipulation**: Schema alterations (e.g., adding a `JoiningDate` column) and updates applied across the employee dataset

## Tech Stack
- SQL Server (T-SQL)

## Skills Demonstrated
Database design & normalization, window functions, stored procedures, triggers, audit logging, query optimization
