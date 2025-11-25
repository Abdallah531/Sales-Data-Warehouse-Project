# 📦 Sales Data Warehouse Project

A complete end-to-end data engineering project demonstrating modern data warehousing practices using SQL Server, Medallion Architecture, and ETL pipelines. Built as a portfolio project to showcase practical data engineering skills and real-world analytical capabilities.

---
## 🏗️ Data Architecture
This project follows the Medallion Architecture to ensure scalability, data quality, and clear separation between raw, cleaned, and analytics-ready data.
![Data Architecture](https://github.com/Abdallah531/Sales-Data-Warehouse-Project/blob/main/docs/High%20Level%20Architecture.png)

🔶 **Bronze Layer** – Raw Data  
1- Stores raw data directly from source systems (CSV files).  
2- Loaded into SQL Server without modifications.  
3- Ensures full traceability of original data.  

🔷 **Silver Layer** – Cleaned & Standardized Data  
1- Handles data cleansing, normalization, and validation.  
2- Resolves missing values, formatting issues, and inconsistencies.  
3- Prepares data for modeling and analytics.  

🟡 **Gold Layer** – Business-Ready Data  
1- Final analytical layer modeled using a star schema.  
2- Includes fact and dimension tables optimized for reporting.  
3- Enables fast and accurate analytical queries.  


---
## 📖 Project Overview

This project demonstrates:

1. Modern **Data Architecture** using the Medallion (Bronze/Silver/Gold) model.  
2. **ETL/ELT Pipelines** for extracting, transforming, and loading data.  
3. **Data Modeling** including fact tables and dimension tables.  
4. **Integration** of Multiple Data Sources (ERP + CRM).  
5. **Clear documentation** suitable for business and analytics teams.  

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.



