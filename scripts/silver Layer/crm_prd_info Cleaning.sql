SELECT 
prd_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
FROM bronze.crm_prd_info

-- cheack for primary key is uniqe and not null
select prd_id,count(*) as Numper_of_duplicates
from bronze.crm_prd_info
Group by prd_id
Having count(*) > 1 or prd_id is NULL

-- check for unwanted spaces
select prd_nm
from bronze.crm_prd_info
where prd_nm != TRIM(prd_nm) 

-- check for negative cost 
select prd_cost
from bronze.crm_prd_info
where prd_cost < 0 or prd_cost is null

-- prouduct line checking 
select DISTINCT prd_line,count(*) as Count_status
from bronze.crm_prd_info
group by prd_line

-- checking Logic in date
select *
from bronze.crm_prd_info
where prd_start_dt > prd_end_dt

-- Cleansing
SELECT 
prd_id,
REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,-- extract and transform category ID form product key to make join easily with erp_px_cat_g1v2
SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key ,
prd_nm,
ISNULL(prd_cost,0) as prd_cost,
CASE 
	WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
	WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
	WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
	WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
	ELSE 'N/A'
END AS prd_line, -- Map product line codes to descriptive values
CAST(prd_start_dt AS DATE) AS prd_start_dt,
CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE) AS prd_end_dt -- Calculate end date as one day before the next start date
FROM bronze.crm_prd_info