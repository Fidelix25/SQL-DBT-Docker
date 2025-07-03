
# 🚀 Data Transformation with DBT and Docker (using SQLite)

This project demonstrates how to use [dbt (Data Build Tool)](https://www.getdbt.com/) inside a Docker container to transform data from a CSV file using SQLite as the database engine. It's a minimal, yet powerful, workflow for data modeling, transformations, and documentation.

---

## 🧰 Requirements

- [Docker](https://docs.docker.com/get-docker/) installed and running

---

## ⚙️ Step-by-Step Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/Fidelix25/SQL-DBT-Docker.git
cd sql-dbt-docker
```

### 2. Build the Docker Image

```bash
docker build -t dbt-image .
```

Make sure your `Dockerfile` uses Python 3.11 or 3.10. (Avoid Python 3.12+ due to `distutils` incompatibility.)

### 3. Run the Docker Container

```bash
docker run -dit --name sql-dbt -p 8080:8080 dbt-image
```

### 4. Create a New DBT Project

Inside the container:

```bash
dbt init analyticssql
cd analyticssql
ls -la
```

### 5. Configure DBT Profile for SQLite

Edit the DBT profile file (`~/.dbt/profiles.yml`) with the following configuration:

```yaml
analyticssql:
  outputs:
    dev:
      type: sqlite
      threads: 1
      database: etl.db
      schema: 'main'
      schemas_and_paths:
        main: '/sql-dbt/analyticssql/sql-dbt-data/etl.db'
      schema_directory: '/sql-dbt/analyticssql/sql-dbt-data'

    prod:
      type: sqlite
      threads: 1
      database: <database name>
      schema: 'main'
      schemas_and_paths:
        main: '/my_project/data/etl.db'
      schema_directory: '/my_project/data'
      extensions:
        - '/path/to/sqlite-digest/digest.so'

  target: dev
```

> ℹ️ Replace `<sql-dbt-data>` and extension paths accordingly.

### 6. Create the Data Directory and Add a CSV

```bash
mkdir -p /sql-dbt/analyticssql/sql-dbt-data
cd /sql-dbt/analyticssql/sql-dbt-data
```

Create a file named `sql-dbt-data.csv`:

```csv
id,firstname,salary
1,Alice,3000
2,Bob,2500
3,Charlie,3500
```

### 7. Create and Load the SQLite Database

```bash
sqlite3 /sql-dbt/analyticssql/sql-dbt-data/etl.db
```

Inside the SQLite prompt:

```sql
CREATE TABLE sql-dbt-data_originals (
    id INTEGER,
    firstname TEXT,
    salary INTEGER
);

.mode csv
.import /sql-dbt/analyticssql/sql-dbt-data/sql-dbt-data.csv sql-dbt-data_originals
.quit
```

### 8. Create a DBT Model

Create the SQL model file inside the `models/` directory:

```bash
cd /sql-dbt/analyticssql/models
```

Create a file named `process_sql-dbt-data.sql`:

```sql
WITH source AS (
    SELECT * 
    FROM sql-dbt-data_originals
)

SELECT
    id,
    firstname,
    salary,
    salary * 0.10 AS bonus
FROM source
```

### 9. Run the DBT Model

From the root of your DBT project:

```bash
cd /sql-dbt/analyticssql
dbt run
```

### 10. Verify the Transformation

```bash
sqlite3 /sql-dbt/analyticssql/sql-dbt-data/etl.db
```

Inside the SQLite prompt:

```sql
SELECT * FROM main.sql-dbt-data_originals;
SELECT * FROM main.process_sql-dbt-data;
.quit
```

You should see a new table `process_sql-dbt-data` with a 10% bonus calculation.

---

## 📘 Generate and View DBT Documentation

### 11. Create a Documentation File

Inside the `models/` directory, create a file named `schema.yml`:

```yaml
version: 2

models:
  - name: process_sql-dbt-data
    description: "This model processes salary data and calculates a 10% bonus."
    columns:
      - name: id
        description: "Unique identifier for each record."
      - name: nome
        description: "Name of the person."
      - name: salario
        description: "Base salary of the person."
      - name: bonus
        description: "10% bonus calculated from salary."
```

You may also remove the default `example/` directory if it exists:

```bash
rm -rf example
```

### 12. Build and Serve Documentation

```bash
dbt docs generate
dbt docs serve
```

Access your browser at:

```
http://localhost:8080
```

---

## ✅ Summary

- ✅ Used Docker to isolate DBT environment
- ✅ Loaded CSV data into SQLite
- ✅ Modeled and transformed data with DBT
- ✅ Generated and browsed DBT documentation

---

## 🧠 Learnings

This setup helped me understand DBT workflows inside containers, SQLite integration, and how to document data transformations effectively.

---

## 📂 Directory Structure

```
analyticssql/
├── sql-dbt-data/
│   └── sql-dbt-data.csv
├── models/
│   └── process_sql-dbt-data.sql
│   └── schema.yml
├── dbt_project.yml
└── ...
```

---

## 📄 License

MIT
# SQL-DBT-Docker
