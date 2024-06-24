# Advanced SQL, Oracle PL/SQL, and PostgreSQL PL/pgSQL University Course Project 📘

## Overview 🏫
This repository contains projects developed during a university course on advanced and in-depth **SQL**, **Oracle PL/SQL**, and **PostgreSQL PL/pgSQL**. 
Each phase of the project builds upon the previous, exploring different aspects of database management, data processing, and query optimization.

## Repository Structure 📁
- `Phase1/`: Data Generation
- `Phase2/`: Implementation of Complex Integrity Constraints
- `Phase3/`: Otter Lineage Tracing in PL/SQL
- `Phase4/`: SQL Query Optimization and Analysis
- `Phase5/`: Data Processing and Audit in PostgreSQL
- `README.md`: Main README file for the repository.

## Technology Stack and Concepts 🔧
- **Languages and Frameworks:**
  - **Oracle PL/SQL**
  - **PostgreSQL PL/pgSQL**
  - **Docker** for PostgreSQL server setup

- **Key Concepts:**
  - Procedures, Functions, and Packages
  - Anonymous Blocks
  - Triggers
  - Recursive Queries and Common Table Expressions (CTEs)
  - Data Preprocessing and Validation
  - Indexing and Query Optimization
  - Data Integrity and Constraint Management
  - Data Loading and Exporting
  - Audit Report Generation

## Phase Descriptions 📜

### 1. Data Generation 📑
**Objective:** Generate realistic data for `tbl_CLIENT`, `tbl_PAYMENT`, and `tbl_SERVICE` tables using Oracle PL/SQL.
**Key Elements:**
- Dynamic table drop and creation scripts.
- Procedures for populating tables with synthetic data.

**Reflections and Learnings 🌟**
- This phase involved understanding the data generation process, ensuring data integrity, and effectively using PL/SQL procedures for bulk data operations.

### 2. Implementation of Complex Integrity Constraints 🛠️
**Objective:** Manage data integrity and implement business logic using PL/SQL packages and triggers.
**Key Elements:**
- Package `pkg_iFix_management` for advanced CRUD operations.
- Trigger `trg_CheckServiceCostLimit` to enforce financial constraints based on client privilege levels.

**Reflections and Learnings 🌟**
- This phase highlighted the power of PL/SQL in managing complex business rules and maintaining data integrity through procedural logic and triggers.

### 3. Otter Lineage Tracing in PL/SQL 🦦
**Objective:** Trace the lineage of otters using recursive queries in PL/SQL.
**Key Elements:**
- Recursive Common Table Expressions (CTEs) to retrieve and display otter lineage.
- Procedures and scripts for table creation, data insertion, and lineage tracing.

**Reflections and Learnings 🌟**
- This phase provided practical experience with recursive queries and CTEs, showcasing their effectiveness in handling hierarchical data.

### 4. SQL Query Optimization and Analysis 🛠️
**Objective:** Optimize and analyze SQL queries within the Oracle database environment.
**Key Elements:**
- Execution plan analysis and query refactoring.
- Implementation of indexing, join optimization, and parallel execution.

**Reflections and Learnings 🌟**
- This phase deepened understanding of SQL performance tuning, emphasizing the importance of efficient query design and execution plan analysis.

### 5. Data Processing and Audit in PostgreSQL 🛠️
**Objective:** Process and audit data within PostgreSQL, generating reports and ensuring data integrity.
**Key Elements:**
- Data loading procedure `load_csv_data` for importing data from CSV files.
- Audit report generation procedure `save_csv_audit` for exporting monthly audit data.

**Reflections and Learnings 🌟**
- This phase demonstrated the complete data processing and auditing workflow within a PostgreSQL environment, highlighting practical applications for real-world data management.

## Conclusion 📝
This repository encapsulates a comprehensive learning journey through advanced database management, focusing on both Oracle PL/SQL and PostgreSQL PL/pgSQL. 
The projects demonstrate practical applications of complex SQL concepts, recursive queries, data integrity management, and performance optimization.