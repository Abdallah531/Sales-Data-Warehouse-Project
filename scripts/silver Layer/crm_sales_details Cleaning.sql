SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details

-- check for invalid date
Select NULLIF(sls_order_dt,0) sls_order_dt
from bronze.crm_sales_details
where sls_order_dt is NULL OR LEN(sls_order_dt) != 8

-- check data consistency 
SELECT 
sls_sales As old_sales,
sls_quantity,
sls_price As old_price,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 or sls_sales != sls_quantity * ABS(sls_price)
	then sls_quantity * ABS(sls_price)
	else sls_sales
end as sls_sales,
CASE WHEN sls_price IS NULL OR sls_price <= 0 
	THEN sls_sales / NULLIF(sls_quantity, 0)
	ELSE sls_price  -- Derive price if original value is invalid
END AS sls_price
FROM bronze.crm_sales_details
Where sls_sales != sls_quantity * sls_price
OR sls_price <= 0 or sls_quantity <= 0 or sls_price <=0
OR sls_price IS NULL or sls_quantity IS NULL or sls_price IS NULL


-- Cleansing
SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE 
	WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
END AS sls_order_dt,
CASE 
	WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
END AS sls_ship_dt,
CASE 
	WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
END AS sls_due_dt,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 or sls_sales != sls_quantity * ABS(sls_price)
	THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
end as sls_sales,
sls_quantity,
CASE WHEN sls_price IS NULL OR sls_price <= 0 
	THEN sls_sales / NULLIF(sls_quantity, 0)
	ELSE sls_price  
end as sls_price
FROM bronze.crm_sales_details