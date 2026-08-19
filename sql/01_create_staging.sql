CREATE DATABASE OlistAnalytics;
GO

USE OlistAnalytics;
GO

CREATE SCHEMA staging;
GO

USE OlistAnalytics;


------------------------------------------------------------------------------------------------
--NOTE D'IMPORTATION :
--Les tables du schéma [staging] ont été créées et chargées directement
-- via l'assistant graphique SSMS : "Importer le fichier plat" (Import Flat File).
  
-- - Fichiers importés :
-- - olist_orders_dataset.csv          -> staging.orders
-- - olist_order_items_dataset.csv    -> staging.order_items
-- - olist_products_dataset.csv       -> staging.products
-- - olist_customers_dataset.csv      -> staging.customers
-- - olist_order_reviews_dataset.csv  -> staging.reviews
-- - olist_sellers_dataset.csv        -> staging.sellers
-------------------------------------------------------------------------------------------------

SELECT TABLE_SCHEMA, TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'staging';
GO

-- verfier importation de donnees 
SELECT 'orders' AS table_name, COUNT(*) AS nb_lignes FROM staging.orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM staging.order_items
UNION ALL
SELECT 'products', COUNT(*) FROM staging.products
UNION ALL
SELECT 'customers', COUNT(*) FROM staging.customers
UNION ALL
SELECT 'reviews', COUNT(*) FROM staging.reviews
UNION ALL
SELECT 'sellers', COUNT(*) FROM staging.sellers;