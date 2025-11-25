-- *****************************************************************************
-- Create gold.dim_customers
-- *****************************************************************************
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key, -- Surrogate key
    crc.cst_id                          AS customer_id,
    crc.cst_key                         AS customer_number,
    crc.cst_firstname                   AS first_name,
    crc.cst_lastname                    AS last_name,
    el.cntry                           AS country,
    crc.cst_marital_status              AS marital_status,
    CASE 
        WHEN crc.cst_gndr != 'N/A'THEN crc.cst_gndr -- CRM is the primary source for gender
        ELSE COALESCE(ec.gen, 'N/A')  			   -- Fallback to ERP data
    END                                AS gender,
    ec.bdate                           AS birthdate,
    crc.cst_create_date                 AS create_date
FROM silver.crm_cust_info crc
LEFT JOIN silver.erp_cust_az12 ec
    ON crc.cst_key = ec.cid
LEFT JOIN silver.erp_loc_a101 el
    ON crc.cst_key = el.cid;
GO
-- *****************************************************************************
-- Create gold.dim_products
-- *****************************************************************************
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER (ORDER BY cp.prd_start_dt, cp.prd_key) AS product_key, -- Surrogate key
    cp.prd_id       AS product_id,
    cp.prd_key      AS product_number,
    cp.prd_nm       AS product_name,
    cp.cat_id       AS category_id,
    ep.cat          AS category,
    ep.subcat       AS subcategory,
    ep.maintenance  AS maintenance,
    cp.prd_cost     AS cost,
    cp.prd_line     AS product_line,
    cp.prd_start_dt AS start_date
FROM silver.crm_prd_info cp
LEFT JOIN silver.erp_px_cat_g1v2 ep
    ON cp.cat_id = ep.id
WHERE cp.prd_end_dt IS NULL; -- Filter all historical data
GO


-- *****************************************************************************
-- Create gold.fact_sales
-- *****************************************************************************
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    cs.sls_ord_num  AS order_number,
    dp.product_key  AS product_key,
    cu.customer_key AS customer_key,
    cs.sls_order_dt AS order_date,
    cs.sls_ship_dt  AS shipping_date,
    cs.sls_due_dt   AS due_date,
    cs.sls_sales    AS sales_amount,
    cs.sls_quantity AS quantity,
    cs.sls_price    AS price
FROM silver.crm_sales_details cs
LEFT JOIN gold.dim_products dp
    ON cs.sls_prd_key = dp.product_number
LEFT JOIN gold.dim_customers cu
    ON cs.sls_cust_id = cu.customer_id;
GO
