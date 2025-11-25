SELECT 
id,
cat,
subcat,
maintenance
FROM bronze.erp_px_cat_g1v2

-- check for unwanted spacing
SELECT 
cat
FROM bronze.erp_px_cat_g1v2
where cat != TRIM(cat)
-- excellent

-- check for unwanted spacing
SELECT 
subcat
FROM bronze.erp_px_cat_g1v2
where subcat != TRIM(subcat)
-- excellent

SELECT DISTINCT maintenance, count(*)
FROM bronze.erp_px_cat_g1v2
GROUP by maintenance

/*
NO NEED FOR DATA CLEANING OR TRANSFORMATION FOR THIS TABLE
*/

