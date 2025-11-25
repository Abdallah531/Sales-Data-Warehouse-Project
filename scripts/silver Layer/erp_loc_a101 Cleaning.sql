SELECT cid,cntry
FROM bronze.erp_loc_a101
-- compare customer key in crm customer info   with cid in erp_loc_a101
select cst_key from silver.crm_cust_info

-- Checking country col
SELECT DISTINCT cntry, count(*)
FROM bronze.erp_loc_a101
GROUP by cntry



-- Cleansing
SELECT 
REPLACE(cid,'-','') AS cid,
CASE
	WHEN TRIM(cntry) = 'DE' THEN 'Germany'
	WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
	WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'N/A'
	ELSE TRIM(cntry)
END AS cntry
FROM bronze.erp_loc_a101