SELECT 
cid,
bdate,
gen
FROM bronze.erp_cust_az12

-- compare customer key in crm customer info   with cid in erp_cust_az12

SELECT *
FROM silver.crm_cust_info

-- check if any one bdate in the future
SELECT 
bdate
FROM bronze.erp_cust_az12
WHERE bdate > GETDATE()

-- cheaking for Gender
SELECT DISTINCT gen, count(*)
FROM bronze.erp_cust_az12
GROUP BY gen


-- Cleansing
SELECT 
CASE WHEN cid LIKE 'NAS%' then SUBSTRING(cid,4,LEN(cid))
else cid
end as cid,
CASE WHEN bdate > GETDATE() then NULL
else bdate
end as bdate,
CASE WHEN gen IN ('F', 'Female') then 'Female'
  	 WHEN gen IN ('M', 'Male') then 'Male'
	 ELSE 'N/A'
END as gen
FROM bronze.erp_cust_az12