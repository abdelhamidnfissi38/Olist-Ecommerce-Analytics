----------------------------------------------------------------------
-- 01 - CREATION DU STAR SCHEMA
----------------------------------------------------------------------
-- 1. Création du schéma propre
create schema dw;
go

----------------------------------------------------------------------
-- DIMENSION : PRODUCTS
-- Grain : 1 ligne = 1 produit
----------------------------------------------------------------------

create table dw.dim_products (
    product_key int identity(1,1) primary key,
    product_id varchar(50) not null,
    product_category_name varchar(100),
    product_weight_g decimal(10,2),
    product_length_cm decimal(10,2),
    product_height_cm decimal(10,2),
    product_width_cm decimal(10,2)
);
go
----------------------------------------------------------------------
-- DIMENSION : CUSTOMERS
-- Grain : 1 ligne = 1 customer_id
----------------------------------------------------------------------


create table dw.dim_customers (
    customer_key int identity(1,1) primary key,
    customer_id varchar(50) not null,
    customer_unique_id varchar(50) not null,
    customer_zip_code_prefix int,
    customer_city varchar(100),
    customer_state varchar(10)
);
go
----------------------------------------------------------------------
-- DIMENSION : SELLERS
-- Grain : 1 ligne = 1 vendeur
----------------------------------------------------------------------

create table dw.dim_sellers (
    seller_key int identity(1,1) primary key,
    seller_id varchar(50) not null,
    seller_zip_code_prefix int,
    seller_city varchar(100),
    seller_state varchar(10)
);
go
----------------------------------------------------------------------
-- DIMENSION : DATE
-- Grain : 1 ligne = 1 date
----------------------------------------------------------------------

create table dw.dim_date (
    date_key int primary key,
    full_date date not null,
    day int not null,
    month int not null,
    month_name varchar(20) not null,
    quarter int not null,
    year int not null
);
go
----------------------------------------------------------------------
-- TABLE DE FAITS : SALES
-- Grain : 1 ligne = 1 article vendu dans une commande
----------------------------------------------------------------------


create table dw.fact_sales (
    order_id varchar(50) not null,
    order_item_id int not null,

    product_key int not null,
    customer_key int not null,
    seller_key int not null,
    purchase_date_key int null,

    price decimal(18,2),
    freight_value decimal(18,2),

    order_status varchar(30),
    order_delivered_customer_date datetime2,
    order_estimated_delivery_date datetime2,

    constraint PK_fact_sales
        primary key (order_id, order_item_id),

    constraint  FK_fact_sales_product
        foreign key (product_key)
        references dw.dim_products(product_key),

    constraint FK_fact_sales_customer
        foreign key (customer_key)
        references dw.dim_customers(customer_key),

    constraint FK_fact_sales_seller
        foreign key (seller_key)
        references dw.dim_sellers(seller_key),

    constraint FK_fact_sales_date
        foreign key (purchase_date_key)
        references dw.dim_date(date_key)
);
go