------------------------------------------------------------------------------------
-- 1. VALEURS MANQUANTES
------------------------------------------------------------------------------------
-- 1.1 Orders
select 
	count(*) as total_rows,
	sum(case when order_id is null then 1 else 0 end) as null_order_id,
	sum(case when customer_id is null then 1 else 0 end) as null_customer_id,
	sum(case when order_status is null then 1 else 0 end) as null_order_status,
	sum(case when order_purchase_timestamp is null then 1 else 0 end) as null_purchase_timestamp,
	sum(case when order_approved_at is null then 1 else 0 end) as null_order_approved_at,
	sum(case when order_delivered_carrier_date is null then 1 else 0 end ) as order_delivered_carrier_date,
	sum(case when order_delivered_customer_date is null then 1 else 0 end) as order_delivered_customer_date,
	sum(case when order_estimated_delivery_date is null then 1 else 0 end) as order_estimated_delivery_date
from staging.orders;

------------------------------------------------------------------------------------

-- 1.2 Order Items
select
    count(*) as total_rows,
    sum(case when order_id is null then 1 else 0 end) as null_order_id,
    sum(case when order_item_id is null then 1 else 0 end) as null_order_item_id,
    sum(case when product_id is null then 1 else 0 end) as null_product_id,
    sum(case when seller_id is null then 1 else 0 end) as null_seller_id,
    sum(case when shipping_limit_date is null then 1 else 0 end) as null_shipping_limit_date,
    sum(case when price is null then 1 else 0 end) as null_price,
    sum(case when freight_value is null then 1 else 0 end) as null_freight_value
from staging.order_items;
------------------------------------------------------------------------------------

-- 1.3 Products

select
    count(*) as total_rows,

    sum(case when product_id IS NULL then 1 else 0 end) AS null_product_id,
    sum(case when product_category_name IS NULL then 1 else 0 end) as null_category,
    sum(case when product_name_lenght IS NULL then 1 else 0 end) as null_name_length,
    sum(case when product_description_lenght IS NULL then 1 else 0 end) as null_description_length,
    sum(case when product_photos_qty IS NULL then 1 else 0 end) as null_photos_qty,
    sum(case when product_weight_g IS NULL then 1 else 0 end) as null_weight,
    sum(case when product_length_cm IS NULL then 1 else 0 end) as null_length,
    SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END) AS null_height,
    SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) AS null_width

from staging.products;

select *
from staging.products
where product_category_name IS NULL
   or product_name_lenght IS NULL
   or product_description_lenght IS NULL
   or product_photos_qty IS NULL

------------------------------------------------------------------------------------


-- 1.4 Customers

select
    count(*) as total_rows,
    sum(case when customer_id is null then 1 else 0 end) as null_customer_id,
    sum(case when customer_unique_id is null then 1 else 0 end) as null_customer_unique_id,
    sum(case when customer_zip_code_prefix is null then 1 else 0 end) as null_zip_code,
    sum(case when customer_city is null then 1 else 0 end) as null_city,
    sum(case when customer_state is null then 1 else 0 end) as null_state
from staging.customers;
------------------------------------------------------------------------------------

-- 1.5 Reviews

select
    count(*) as total_rows,

    sum(case when review_id is null then 1 else 0 end) as null_review_id,
    sum(case when order_id is null then 1 else 0 end) as null_order_id,
    sum(case when review_score is null then 1 else 0 end) as null_review_score,
    sum(case when review_comment_title is null then 1 else 0 end) as null_comment_title,
    sum(case when review_comment_message is null then 1 else 0 end) as null_comment_message,
    sum(case when review_creation_date is null then 1 else 0 end) as null_creation_date,
    sum(case when review_answer_timestamp is null then 1 else 0 end) as null_answer_timestamp

from staging.reviews;

------------------------------------------------------------------------------------

-- 1.6 Sellers

SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS null_seller_id,
    SUM(CASE WHEN seller_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS null_zip_code,
    SUM(CASE WHEN seller_city IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN seller_state IS NULL THEN 1 ELSE 0 END) AS null_state
FROM staging.sellers;
------------------------------------------------------------------------------------
-- 2. CONTROLE DES DOUBLONS
------------------------------------------------------------------------------------

-- 2.1 Orders
-- Clé attendue : order_id

select 
    order_id,
    count(*) as occurrences
from staging.orders
group by order_id
having count(*)>1
------------------------------------------------------------------------------------

-- 2.2 Order Items
-- Clé attendue : (order_id, order_item_id)

select 
    order_id,
    order_item_id,
    count(*) as occurrences
from staging.order_items
group by order_id,order_item_id
having count(*) >1
------------------------------------------------------------------------------------

-- 2.3 Products
-- Clé attendue : product_id

select
    product_id,
    count(*) as occurrences
from staging.products
group by product_id
having count(*) > 1
------------------------------------------------------------------------------------

-- 2.4 Customers
-- Clé attendue : customer_id

select
    customer_id,
    count(*) AS occurrences
from staging.customers
group by customer_id
having count(*) > 1
------------------------------------------------------------------------------------

-- 2.5 Reviews
-- Clé attendue : (review_id, order_id)

select
    review_id,
    order_id,
    count(*) as occurrences
from staging.reviews
group by review_id, order_id
having count(*) > 1
------------------------------------------------------------------------------------

-- 2.6 Sellers
-- Clé attendue : seller_id

select
    seller_id,
    count(*) as occurrences
from staging.sellers
group by seller_id
having count(*) > 1

------------------------------------------------------------------------------------
-- 3. CONTROLE DES VALEURS INVALIDES
------------------------------------------------------------------------------------


/* 3.1 Order Items
 Règles :
 price >= 0
 freight_value >= 0
*/

select *
from staging.order_items
where price < 0
   OR freight_value < 0

------------------------------------------------------------------------------------

-- 3.2 Reviews
-- Règle : review_score doit être compris entre 1 et 5

select *
from staging.reviews
where review_score < 1
   OR review_score > 5


------------------------------------------------------------------------------------
-- 3.3 Products
-- Règles :
-- product_weight_g > 0
-- product_length_cm > 0
-- product_height_cm > 0
-- product_width_cm > 0

select *
from staging.products
where product_weight_g <= 0
   OR product_length_cm <= 0
   OR product_height_cm <= 0
   OR product_width_cm <= 0;
/*
Résultat :
4 produits ont un poids égal à 0 g.
Ces valeurs sont considérées comme invalides pour l'analyse Weight vs Sales.
*/
------------------------------------------------------------------------------------
-- 4. CONTROLE DES DATES INCOHERENTES
------------------------------------------------------------------------------------

-- 4.1 Orders
-- Une commande ne peut pas être approuvée avant son achat


select count(*)
from staging.orders
where order_approved_at < order_purchase_timestamp

------------------------------------------------------------------------------------
-- Une commande ne peut pas être remise au transporteur
-- avant d'avoir été achetée

select count(*) as nb_incoherences
from staging.orders
where order_delivered_carrier_date < order_purchase_timestamp

-- Anomalie détectée :
-- Certaines commandes ont une date de remise au transporteur
-- antérieure à la date d'achat.
-- Ces lignes seront considérées comme incohérentes et devront
-- être traitées avant le chargement du Data Warehouse.

------------------------------------------------------------------------------------
-- Une commande ne peut pas être livrée au client
-- avant d'avoir été remise au transporteur

select count(*)
from staging.orders
where order_delivered_customer_date < order_delivered_carrier_date;
-- Résultat :
-- 23 commandes ont une date de livraison client
-- antérieure à la date de remise au transporteur.
-- Ces lignes devront être traitées avant le chargement du Data Warehouse.
------------------------------------------------------------------------------------

-- vérifier qu’aucune commande n’a été livrée au client avant même son achat.
SELECT count(*)
FROM staging.orders
WHERE order_delivered_customer_date < order_purchase_timestamp;
--Aucune commande n’a été livrée au client avant sa date d’achat. 

------------------------------------------------------------------------------------
--Une date de livraison estimée antérieure à la date d’achat serait impossible.
select count(*)
from staging.orders
where order_estimated_delivery_date < order_purchase_timestamp;
--Aucune date de livraison estimée n’est antérieure à la date d’achat. 

------------------------------------------------------------------------------------

-- 5. CONTROLE DES TYPES DE DONNEES

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'staging'

-- Résultat :
-- Les types de données du staging correspondent aux types attendus
-- Aucune incohérence de type détectée après le chargement

------------------------------------------------------------------------------------
-- 6. controle de l'integrite referentielle
------------------------------------------------------------------------------------
-- 6.1 order_items -> orders
-- chaque order_id de order_items doit exister dans orders

select count(*)
from staging.order_items as oi
left join staging.orders as o
    on oi.order_id = o.order_id
where o.order_id is null
--Aucun order_id orphelin dans order_items

------------------------------------------------------------------------------------

-- 6.2 order_items -> products
-- Chaque product_id de order_items doit exister dans products

select count(*)
from staging.order_items as oi
left join staging.products as pr
    on oi.product_id=pr.product_id
where pr.product_id is null
--Aucun product_id orphelin dans order_items

------------------------------------------------------------------------------------

-- 6.3 order_items -> sellers
-- Chaque seller_id de order_items doit exister dans sellers

select count(*)
from staging.order_items as oi
left join staging.sellers as s
    on oi.seller_id = s.seller_id
where s.seller_id is null
--Aucun seller_id orphelin dans order_items

------------------------------------------------------------------------------------

-- 6.4 orders -> customers
-- Chaque customer_id de orders doit exister dans customers

select count(*)
from staging.orders as o
left join staging.customers as c
    on o.customer_id = c.customer_id
where c.customer_id is null
--Aucun customer_id orphelin dans order

------------------------------------------------------------------------------------

-- 6.5 reviews -> orders
-- Chaque order_id de reviews doit exister dans orders

select count(*)
from staging.reviews as r
left join staging.orders o
    on r.order_id=o.order_id
where o.order_id is null 
--Aucun order_id orphelin dans reviews

------------------------------------------------------------------------------------
-- 7. CONTROLE DE COHERENCE AVEC LES REGLES METIER
------------------------------------------------------------------------------------

-- 7.1 Commandes livrées sans date de livraison client

select  *
from staging.orders
where order_status = 'delivered'
  and order_delivered_customer_date is null

-- Résultat :
-- 8 commandes avec le statut 'delivered' n'ont pas de date de livraison client.
-- Ces lignes sont incohérentes avec la logique métier et devront être traitées
-- avant le chargement du Data Warehouse.


------------------------------------------------------------------------------------

-- 7.2 Commandes livrées sans date de remise au transporteur


select *
from staging.orders
where order_status = 'delivered'
  and order_delivered_carrier_date is null

-- Résultat :
-- 2 commandes avec le statut 'delivered' n'ont pas de date de remise au transporteur.
-- Ces lignes sont incohérentes avec la logique métier et devront être
-- traitées avant le chargement du Data Warehouse.

------------------------------------------------------------------------------------

-- 7.3 Commandes livrées sans date d'approbation

select *
from staging.orders
where order_status = 'delivered'
  and order_approved_at is null

-- Résultat :
-- 14 commandes avec le statut 'delivered' n'ont pas de date d'approbation.
-- Ces lignes sont incohérentes avec la logique métier et devront être
-- traitées avant le chargement du Data Warehouse.




-- =====================================================================================
-- NOTE
-- La synthèse détaillée des contrôles de qualité, les anomalies
-- détectées et leur interprétation sont documentées dans :
-- docs/data_quality_report.md
-- =======================================================================================