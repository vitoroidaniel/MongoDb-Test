# MongoDb-Test
![Image](./images/example.png)
# Test Database for an IT Company

This repository contains scripts and data for setting up a test database for an IT company. The database includes collections for employees, departments, and children associated with employees.

## Database Setup

The database is designed using MongoDB. To set up the database, follow these steps:

1. Install MongoDB on your system if you haven't already.
2. Start the MongoDB service.
3. Use the provided Python script to add, delete, and update data in the database.

## Collections

### Employee
- Fields:
  - id_emp (Employee ID)
  - id_department (Department ID)
  - name_emp (Employee Name)
  - surname_emp (Employee Surname)
  - address_emp (Employee Address)
  - gender_emp (M/F)
  - date_birth_emp (Date of Birth)
  - idnp_emp (Employee ID Number)
  - position (Employee Position)
  - hiredate_emp (Hire Date)
  - hours_worked (Hours Worked)
  - hourly_rate (Hourly Rate)
  - total_salary (Total Salary)
  - num_childrens (Number of Children)

### Department
- Fields:
  - id_department (Department ID)
  - depart_name (Department Name)

### Childrens
- Fields:
  - id_child (Child ID)
  - id_emp (Employee ID)
  - child_name (Child Name)
  - child_surname (Child Surname)

## Python Script

The Python script `manage_db.py` provides functionalities to add, delete, and update data in the MongoDB database. It also includes functionality to export the database to JSON format.

### Usage:

1. Make sure you have Python installed on your system.
2. Install the required Python packages by running `pip install pymongo`.
3. Run the script using `python manage_db.py`.

Have fun, also I will add a little documentation/guide for how to install MongoDb and basic of MongoDb
