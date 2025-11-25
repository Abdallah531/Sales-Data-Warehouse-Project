/*
This script is for data investigation and cleaning and transformtion for crm_cust_info
*/
-- show data
select * from bronze.crm_cust_info;
-- cheack for primary key is uniqe and not null
select cst_id,count(*) as Numper_of_duplicates
from bronze.crm_cust_info
Group by cst_id
Having count(*) > 1 or cst_id is NULL

-- check for unwanted spaces
select cst_firstname, cst_lastname
from bronze.crm_cust_info
where cst_firstname != TRIM(cst_firstname) or cst_lastname != TRIM(cst_lastname)

-- gender checking 
select DISTINCT cst_gndr,count(*) as Count_gender
from bronze.crm_cust_info
group by cst_gndr

-- marital_status checking 
select DISTINCT cst_marital_status,count(*) as Count_status
from bronze.crm_cust_info
group by cst_marital_status


-- Cleansing
select 
cst_id,
cst_key,
TRIM(cst_firstname) as cst_firstname,
TRIM(cst_lastname) as cst_lastname,
CASE WHEN cst_marital_status = 'S' then 'Single'
  	 WHEN cst_marital_status = 'M' then 'Married'
	 ELSE 'N/A'
END as cst_marital_status,
CASE WHEN cst_gndr = 'F' then 'Female'
  	 WHEN cst_gndr = 'M' then 'Male'
	 ELSE 'N/A'
END as cst_gndr,
cst_create_date
from(
	select * , ROW_NUMBER() over (partition by cst_id order by cst_create_date desc) as flag_number
	from bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
	)t where flag_number = 1
