# Natural Language to SQL Query Application with Claude and MCP

This project enables natural language queries to a PostgreSQL database through the Model Context Protocol (MCP). Users can ask questions in plain English, and the application will generate the appropriate SQL query, execute it, and display the results.

## Features

- **Natural Language Interface**: Ask questions about your database in plain English
- **SQL Query Generation**: Automatic translation of natural language to SQL using Claude
- **Interactive Web Interface**: User-friendly Streamlit application
- **Query Examples**: Pre-built examples to help you get started
- **Results Export**: Download your query results as CSV files
- **Configurable Models**: Choose between Claude models for different performance needs

## What is the Model Context Protocol (MCP)?

The Model Context Protocol (MCP) is a standard for connecting large language models (LLMs) like Claude with external data sources and tools. MCP allows LLMs to interact directly with databases, enabling natural language queries to structured data without the need to manually write SQL.

### Key features of MCP:

- **Direct Connection**: Provides LLMs with direct access to structured data
- **Security**: Models can query data without needing to expose the entire database content
- **Flexibility**: Compatible with different database engines like PostgreSQL
- **Schema Interpretation**: The model automatically interprets the database structure

## Architecture and Connection Flow

The application implements a client-server architecture that connects user interfaces with an LLM and a PostgreSQL database. Here's how the connection flow works:

### Main Components:

1. **User Interface (Streamlit)**: Web interface where users enter natural language queries
2. **MCP Client (Python)**: Manages communication between the UI, Claude, and PostgreSQL
3. **MCP Server**: Facilitates the connection between Claude and the PostgreSQL database
4. **Claude Model**: Processes natural language and generates SQL queries
5. **PostgreSQL Database**: Stores and manages the structured data

## Benefits of This Architecture

1. **Separation of Concerns**: Each component has a clearly defined function
2. **Scalability**: Components can scale independently
3. **Flexibility**: Easy to adapt to different database engines or AI models
4. **Enhanced User Experience**: Users don't need to know SQL to query data
5. **Security**: Access control to the database through the MCP server

## Installation

### Prerequisites

- Python 3.7+
- Node.js and npm
- PostgreSQL
- EC2
- AWS CLI

### Step 1: Update System and Install Node.js

```bash
sudo apt update
sudo apt install -y nodejs npm
```

### Step 2: Install MCP Server for PostgreSQL

```bash
sudo npm install -g @modelcontextprotocol/server-postgres
npm list -g @modelcontextprotocol/server-postgres  # Verify installation
```

### Step 3: Set Up Python Environment

```bash
sudo apt install -y python3-venv
pip install anthropic
pip install psycopg2-binary
pip install streamlit
pip install pandas
```

### Step 4: Install PostgreSQL

```bash
sudo apt install -y postgresql postgresql-contrib
```

### Step 5: Configure PostgreSQL

```bash
# Access PostgreSQL as postgres user
sudo -i -u postgres
psql

# Create a user for the application
CREATE USER mcp_user WITH PASSWORD '123456';
\du  # Verify user creation

# Create a database and grant privileges
CREATE DATABASE mcp_db OWNER mcp_user;
GRANT ALL PRIVILEGES ON DATABASE mcp_db TO mcp_user;
\l  # List databases
\q  # Exit psql
```

### Step 6: Create Database Schema and Sample Data

```bash
# Connect to the database as mcp_user
PGPASSWORD=123456 psql -U mcp_user -d mcp_db
```

#### Create Tables

```sql
-- Create departments table
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL
);

-- Create employees table
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hire_date DATE NOT NULL,
    salary NUMERIC(10,2) NOT NULL,
    department_id INTEGER REFERENCES departments(id)
);

-- Create projects table
CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    budget NUMERIC(12,2) NOT NULL,
    status VARCHAR(20) NOT NULL
);

-- Create assignments table
CREATE TABLE assignments (
    employee_id INTEGER REFERENCES employees(id),
    project_id INTEGER REFERENCES projects(id),
    assignment_date DATE NOT NULL,
    role VARCHAR(100) NOT NULL,
    PRIMARY KEY (employee_id, project_id)
);
```

#### Insert Sample Data

```sql
-- Insert data into departments
INSERT INTO departments (name, location) VALUES
('Technology', 'Floor 3'),
('Human Resources', 'Floor 1'),
('Sales', 'Floor 2'),
('Marketing', 'Floor 2'),
('Finance', 'Floor 4');

-- Insert data into employees
INSERT INTO employees (first_name, last_name, email, hire_date, salary, department_id) VALUES
('John', 'Smith', 'john.smith@company.com', '2020-03-15', 75000.00, 1),
('Mary', 'Johnson', 'mary.johnson@company.com', '2019-07-10', 68000.00, 2),
('Charles', 'Rodriguez', 'charles.rodriguez@company.com', '2021-01-20', 82000.00, 3),
('Anna', 'Martinez', 'anna.martinez@company.com', '2020-11-05', 79000.00, 1),
('Robert', 'Lopez', 'robert.lopez@company.com', '2018-05-12', 90000.00, 5),
('Laura', 'Sanchez', 'laura.sanchez@company.com', '2022-02-28', 65000.00, 4),
('Michael', 'Torres', 'michael.torres@company.com', '2021-08-15', 71000.00, 3);

-- Insert data into projects
INSERT INTO projects (name, start_date, end_date, budget, status) VALUES
('ERP Implementation', '2022-02-01', '2022-11-30', 250000.00, 'Completed'),
('Mobile App Development', '2022-04-15', '2023-02-15', 180000.00, 'In progress'),
('Cloud Migration', '2022-06-01', NULL, 350000.00, 'In progress'),
('Website Redesign', '2022-03-10', '2022-07-30', 95000.00, 'Completed'),
('Process Automation', '2022-08-01', NULL, 120000.00, 'Planning');

-- Insert data into assignments
INSERT INTO assignments (employee_id, project_id, assignment_date, role) VALUES
(1, 1, '2022-02-01', 'Backend Developer'),
(1, 3, '2022-06-01', 'DevOps Engineer'),
(2, 1, '2022-02-15', 'Coordinator'),
(3, 2, '2022-04-15', 'Project Manager'),
(4, 2, '2022-04-20', 'UX Designer'),
(4, 4, '2022-03-10', 'UI Designer'),
(5, 3, '2022-06-15', 'Financial Analyst'),
(5, 5, '2022-08-01', 'Coordinator'),
(6, 4, '2022-03-15', 'SEO Specialist'),
(7, 2, '2022-05-01', 'Frontend Developer');

-- Verify the data
SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM projects;
SELECT * FROM assignments;

-- Exit psql
\q
```

## Running the Application

### Step 1: Set Up Environment Variables (Optional)

```bash
export ANTHROPIC_API_KEY="your_api_key_here"
export PG_CONNECTION="postgresql://mcp_user:123456@localhost:5432/mcp_db"
```

### Step 2: Run the Streamlit App

```bash
streamlit run streamlit_app.py
```

The application will be available at http://localhost:8501 by default.

## Usage

1. Enter your Anthropic API key in the sidebar (if not set via environment variable)
2. Verify the PostgreSQL connection string
3. Enter a question in natural language about the database (e.g., "How many employees are in each department?")
4. Click "Execute Query" to process your request
5. View the results, SQL query, and Claude's complete response in the tabs
6. Download results as CSV if needed

## Example Queries

- How many employees are in the Technology department?
- What is the average salary by department?
- Which projects are currently in progress?
- Who is the employee with the highest salary?
- In which projects does John Smith participate?

## Files in this Project

- **mcp_client.py**: Core functionality for connecting Claude with PostgreSQL
- **streamlit_app.py**: Web interface for the application

## Requirements

- Anthropic API key (Claude access)
- PostgreSQL database
- Node.js and npm
- Python 3.7+
- Required Python packages: anthropic, psycopg2-binary, streamlit, pandas

## Troubleshooting

- If you encounter connection issues, verify that PostgreSQL is running
- Check that the Model Context Protocol server is installed correctly
- Verify your API key and PostgreSQL connection string
- If queries time out, consider using a faster Claude model

## License

This project is licensed under the MIT License - see the LICENSE file for details.
