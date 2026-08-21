use OlistAnalytics;
go

-- ------------------------------------------------------------
-- 04 - chargement  du data warehouse
-- ------------------------------------------------------------


-- ------------------------------------------------------------
-- 1. Chargement de dim_products
-- grain : 1 ligne = 1 produit


INSERT INTO dw.dim_products (
    product_id,
    product_category_name,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
SELECT
    product_id,

    COALESCE(product_category_name, 'Unknown') AS product_category_name,

    CASE
        WHEN product_weight_g <= 0 THEN NULL
        ELSE product_weight_g
    END AS product_weight_g,

    product_length_cm,
    product_height_cm,
    product_width_cm

FROM staging.products;

-- verifier le chargement
select 
    case 
        when (select count(*) FROM dw.dim_products) = (select count(*) from staging.products) 
        then 'true' 
        else 'false' 
    end as chargement_ok;
-- ------------------------------------------------------------
-- 2. Chargement de dim_customers
-- grain : 1 ligne = 1 customer_id
-- ------------------------------------------------------------

insert into dw.dim_customers(
    customer_id ,
    customer_unique_id ,
    customer_zip_code_prefix,
    customer_city ,
    customer_state 
)
select 
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
from staging.customers;

-- verifier le chargement
select 
    case 
        when (select count(*) from staging.customers) = (select count(*) from dw.dim_customers)
        then 'true'
        else 'false'
    end as chargement_ok;


-- ------------------------------------------------------------
-- 2. Chargement de dim_sellers
-- Grain : 1 ligne = 1 vendeur
-- ------------------------------------------------------------

insert into dw.dim_sellers(
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
)
select 
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state

from staging.sellers;

-- verifier le chargement
select 
    case 
        when (select count(*) from staging.sellers) = (select count(*) from dw.dim_sellers)
        then 'true'
        else 'false'
    end as chargement_ok;

-- ------------------------------------------------------------
-- Chargement de dim_date
-- Grain : 1 ligne = 1 date
-- Source : order_purchase_timestamp
-- ------------------------------------------------------------
select count(order_purchase_timestamp) from staging.orders
INSERT INTO dw.dim_date (
    date_key,
    full_date,
    day,
    month,
    month_name,
    quarter,
    year
)
SELECT DISTINCT
    CONVERT(INT, CONVERT(CHAR(8), order_purchase_timestamp, 112)) AS date_key,
    CONVERT(DATE, order_purchase_timestamp) AS full_date,
    DAY(order_purchase_timestamp) AS day,
    MONTH(order_purchase_timestamp) AS month,
    DATENAME(MONTH, order_purchase_timestamp) AS month_name,
    DATEPART(QUARTER, order_purchase_timestamp) AS quarter,
    YEAR(order_purchase_timestamp) AS year
FROM staging.orders
WHERE order_purchase_timestamp IS NOT NULL;

-- verifier le chargement
select 
    case 
        when (select count(*) from dw.dim_date)=(select count(distinct convert(date, order_purchase_timestamp)) from staging.orders)
        then'true'
        else 'false'
        end as chargement_ok;




-- ------------------------------------------------------------
-- Chargement de fact_sales
-- Grain : 1 ligne = 1 article vendu dans une commande
-- ------------------------------------------------------------



insert into dw.fact_sales (
    order_id,
    order_item_id,
    product_key,
    customer_key,
    seller_key,
    purchase_date_key,
    price,
    freight_value,
    order_status,
    order_delivered_customer_date,
    order_estimated_delivery_date
)
select
    oi.order_id,
    oi.order_item_id,

    dp.product_key,
    dc.customer_key,
    ds.seller_key,
    dd.date_key,

    oi.price,
    oi.freight_value,

    o.order_status,

    case
        when o.order_delivered_customer_date < o.order_purchase_timestamp
            then null
        else o.order_delivered_customer_date
    end as order_delivered_customer_date,

    o.order_estimated_delivery_date

from staging.order_items as oi

inner join staging.orders as o
    on oi.order_id = o.order_id

inner join dw.dim_products as dp
    on oi.product_id = dp.product_id

inner join dw.dim_customers as dc
    on o.customer_id = dc.customer_id

inner join dw.dim_sellers as ds
    on oi.seller_id = ds.seller_id

inner join dw.dim_date as dd
    on convert(date, o.order_purchase_timestamp) = dd.full_date;


-- verifier le chargement

select
    case    
        when (select count(*) from staging.order_items)=(select count(*) from dw.fact_sales) 
        then 'true'
        else 'false'
        end as chargement_ok;
/*
parce que le grain de fact_sales est :

1 ligne = 1 article vendu dans une commande

et staging.order_items a exactement ce même grain
*/

--verifier que les mesures financieres n’ont pas change

select 
    case 
        when (select sum(price) from staging.order_items)=(select sum(price) from dw.fact_sales) and (select sum(freight_value) from staging.order_items)=(select sum(freight_value) from dw.fact_sales)
        then 'true'
        else 'false'
        end as  mesure_financieres_pas_change


select 
    sum(case when product_key is null then 1 else 0 end) as null_product_key,
    sum(case when customer_key is null then 1 else 0 end) as null_customer_key,
    sum(case when seller_key is null then 1 else 0 end) as null_seller_key,
    sum(case when purchase_date_key is null then 1 else 0 end) as null_date_key
from dw.fact_sales;