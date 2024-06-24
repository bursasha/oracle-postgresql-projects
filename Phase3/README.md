# 3. Otter Lineage Tracing in PL/SQL 🦦

## Project Structure 📁
- `procedure/`: Contains PL/SQL procedures for lineage tracing.
- `script/`: Contains PL/SQL scripts for table creation and data insertion.
- `LOG.md`: Log file for tracking project progress.
- `README.md`: The main README file for the project.

## Description of the Entire Phase 🔎
In this phase, we focus on tracing the lineage of otters in a wildlife reserve database using PL/SQL. 
The main objectives include creating and populating the necessary tables, implementing a procedure to retrieve otter lineages, and executing test blocks to validate the procedure. 
The approach involves using recursive queries and **Common Table Expressions** (CTEs) to navigate through the `VYDRA` table and retrieve ancestral information based on specified criteria.

## Objectives 📍
1. Create and populate the `vydra` and `revir` tables.
2. Implement the `proc_GetLineage` procedure to retrieve otter lineages.
3. Execute test blocks to validate the procedure.

## Database Structure and Records 📊
The following tables and their structures are used in this phase:

### 1. `revir` Table: 🌊
- **Objective:** Store information about wildlife reserves.
- **Columns:**
  - `crev`: Unique identifier for the reserve.
  - `nazev`: Name of the reserve.
  - `rozloha`: Area of the reserve.
  - `popis`: Description of the reserve.
- **Constraints:**
  - Primary Key: `revir_pk`.

### 2. `vydra` Table: 🦦
- **Objective:** Store information about otters.
- **Columns:**
  - `cv`: Unique identifier for the otter.
  - `jmeno`: Name of the otter.
  - `otec`: ID of the otter's father.
  - `matka`: ID of the otter's mother.
  - `dnar`: Date of birth.
  - `barva`: Color of the otter.
  - `pohlavi`: Sex of the otter.
  - `crev`: ID of the reserve where the otter is located.
- **Constraints:**
  - Primary Key: `vydra_pk`.
  - Foreign Key: `vydra_o_fk` (references `vydra(cv)`).
  - Foreign Key: `vydra_m_fk` (references `vydra(cv)`).
  - Foreign Key: `vydra_r_fk` (references `revir(crev)`).
  - Check Constraint: `vydra_pohlavi` (values in ('M', 'Z')).
  - Check Constraint: `vydra_barva` (values in ('H', 'B', 'S')).

## Procedure Implementation: `proc_GetLineage` 📦

### Purpose and Functionality 🎯
1. **Objective:** The procedure retrieves the ancestral lineage of a specified otter based on its name and the desired lineage type (male, female, or both).
2. **Complexity:** Utilizes a recursive Common Table Expression (CTE) to traverse the lineage and construct the ancestral tree.

### Key Elements 📍
1. **Parameterized Cursor:** `cur_Lineage` cursor takes otter ID and lineage type as parameters, using a recursive CTE to traverse through the otter family tree.
2. **Lineage Types:** Supports three lineage types: 'MALE', 'FEMALE', and 'BOTH', allowing flexible queries.
3. **Exception Handling:** Handles cases where no otter is found, multiple otters with the same name, and invalid lineage types.

### Procedure Logic 🤔
1. **Validate Otter Name:** Ensures the specified otter name exists in the 'VYDRA' table.
2. **Validate Lineage Type:** Checks if the lineage type is one of 'MALE', 'FEMALE', or 'BOTH'.
3. **Recursive Query:** Uses a recursive CTE to retrieve and order the lineage information.
4. **Output Lineage:** Outputs the ancestral lineage, showing generation, ID, name, sex, and IDs of parents.

## Script Implementation: `script-create.sql` 📜

### Purpose and Functionality 🎯
1. **Create Tables:** Defines the structure of the `revir` and `vydra` tables.
2. **Insert Data:** Populates the tables with initial data.

### Key Elements 📍
1. **Table Definitions:** Specifies columns, data types, and constraints for both tables.
2. **Data Insertion:** Inserts initial records into the `revir` and `vydra` tables.

## Test Block Implementation 📋

### Purpose and Functionality 🎯
1. **Test `proc_GetLineage`:** Validates the functionality of the `proc_GetLineage` procedure with various test cases.

### Key Elements 📍
1. **Test Cases:** Executes the procedure with different otter names and lineage types.
2. **Exception Handling:** Captures and outputs any exceptions that occur during the tests.

## Reflections and Learnings 🌟
This phase of the project was a practical application of PL/SQL for tracing complex hierarchical data structures. 
By leveraging recursive queries and **Common Table Expressions** (CTEs), we were able to efficiently navigate and retrieve ancestral information from the otter database. 
This experience highlighted the power of PL/SQL in handling intricate data relationships and reinforced the importance of robust exception handling to ensure data integrity and reliability. 
The learning curve was challenging but ultimately rewarding, providing valuable insights into advanced SQL techniques and their practical applications. 📈