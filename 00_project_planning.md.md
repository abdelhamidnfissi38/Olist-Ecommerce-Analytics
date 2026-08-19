# Olist E-Commerce Analytics --- Planification du projet

## 1. Vue d'ensemble du projet

### 1.1 Titre du projet

**Olist E-Commerce Analytics : Intelligence Produits, Clients et
Logistique**

### 1.2 Type de projet

Projet **Data Analytics & Business Intelligence de bout en bout**, basé
sur le jeu de données public Olist E-Commerce.

### 1.3 Objectif du projet

Ce projet vise à analyser les données e-commerce d'Olist afin de
produire des informations exploitables autour de trois domaines
principaux :

-   **Performance des produits**
-   **Intelligence client**
-   **Logistique et opérations**

Le projet suit un flux analytique complet :

``` text
Données CSV brutes
        ↓
Python / Pandas — Exploration et compréhension des données
        ↓
SQL Server — Staging et contrôle qualité
        ↓
Schéma en étoile — Data Warehouse
        ↓
SQL — Analyse des KPI métier
        ↓
Power BI — Tableau de bord interactif
        ↓
Insights métier
```

------------------------------------------------------------------------

# 2. Contexte métier

Olist est une plateforme e-commerce brésilienne mettant en relation des
clients et des vendeurs.

L'objectif de cette analyse est d'aider l'entreprise à mieux comprendre
:

-   quels produits et quelles catégories sont les plus et les moins
    performants ;
-   quelles zones géographiques génèrent le plus d'activité ;
-   comment se comporte la fréquence d'achat des clients ;
-   comment la performance des livraisons influence la satisfaction
    client ;
-   si les retards de livraison ont un impact sur l'expérience client.

Le résultat final sera un **tableau de bord Power BI orienté métier**,
alimenté par SQL Server et reposant sur un modèle de données en **schéma
en étoile**.

------------------------------------------------------------------------

# 3. Questions métier

Le projet doit répondre aux questions suivantes.

## 3.1 Performance des produits

-   Quels produits génèrent le chiffre d'affaires le plus élevé ?
-   Quels produits présentent le plus grand volume de ventes ?
-   Quels produits sont les moins performants ?
-   Quelles catégories génèrent le plus et le moins de chiffre
    d'affaires ?
-   Existe-t-il une relation entre le poids d'un produit et sa
    performance commerciale ?
-   Le poids du produit influence-t-il les frais de livraison ?
-   Quels produits très vendus obtiennent de mauvaises évaluations ?

## 3.2 Intelligence client et géographique

-   Quelles villes et quels États génèrent le plus de commandes ?
-   Quelles villes et quels États génèrent le plus de chiffre d'affaires
    ?
-   Quelles zones géographiques sont les moins performantes ?
-   Quel est l'impact de la performance de livraison sur la note
    attribuée par le client ?
-   Quel pourcentage de clients effectuent plus d'une commande ?

## 3.3 Logistique et opérations

-   Quel pourcentage des commandes est livré à temps ?
-   Quel pourcentage des commandes est livré en retard ?
-   Quel est le délai moyen de livraison ?
-   Les retards de livraison sont-ils associés à une satisfaction client
    plus faible ?

------------------------------------------------------------------------

# 4. Indicateurs clés de performance (KPI)

Le projet se concentre sur les KPI suivants.

## A. Performance des produits

### Top & Bottom Products

Identifier :

-   les 10 produits générant le plus de chiffre d'affaires ;
-   les 10 produits générant le moins de chiffre d'affaires ;
-   les 10 produits ayant le plus grand volume de ventes ;
-   les 10 produits ayant le plus faible volume de ventes.

### Meilleures et moins bonnes catégories

Identifier les catégories générant :

-   le chiffre d'affaires le plus élevé ;
-   le chiffre d'affaires le plus faible.

### Analyse Poids vs Ventes

Analyser la relation entre :

-   `product_weight_g` ;
-   le volume des ventes ;
-   `freight_value`.

### Produits très vendus mais mal notés

Identifier les produits qui :

-   présentent un volume de ventes élevé ;
-   obtiennent une note client faible (`<= 2` étoiles).

------------------------------------------------------------------------

## B. Intelligence client et géographique

### Top & Bottom Cities / States

Identifier les villes et États les plus et les moins performants selon :

-   le nombre de commandes ;
-   le chiffre d'affaires.

### Livraison vs Note client

Analyser la relation entre :

-   la performance de livraison ;
-   la note attribuée par le client.

L'objectif est de déterminer si les commandes livrées en retard sont
associées à une satisfaction client plus faible.

### Taux de réachat

Calculer le pourcentage de clients ayant effectué plus d'une commande.

------------------------------------------------------------------------

## C. Logistique et opérations

### Taux de livraison à temps

Pourcentage des commandes pour lesquelles :

``` text
Délai réel <= Délai estimé
```

### Taux de livraison en retard

Pourcentage des commandes pour lesquelles :

``` text
Délai réel > Délai estimé
```

### Délai moyen de livraison

Calculer le nombre moyen de jours nécessaires pour livrer une commande.

------------------------------------------------------------------------

# 5. Périmètre des données

Le jeu de données Olist d'origine contient 9 tables relationnelles.

Pour ce projet, **six tables sont conservées** et **3 tables sont
volontairement écartées**.

## 5.1 Tables conservées

### 1. `olist_orders_dataset`

Contient les informations au niveau de la commande, notamment :

-   identifiant de la commande ;
-   statut de la commande ;
-   date d'achat ;
-   date d'approbation ;
-   date de livraison estimée ;
-   date de livraison réelle.

**Utilisation principale :** analyse du cycle de vie des commandes et de
la livraison.

------------------------------------------------------------------------

### 2. `olist_order_items_dataset`

Contient les informations transactionnelles au niveau de l'article :

-   identifiant de la commande ;
-   identifiant du produit ;
-   identifiant du vendeur ;
-   prix ;
-   frais de livraison.

**Utilisation principale :** analyse des ventes et de la performance des
produits.

------------------------------------------------------------------------

### 3. `olist_products_dataset`

Contient les caractéristiques des produits :

-   identifiant du produit ;
-   catégorie du produit ;
-   poids du produit ;
-   ...

**Utilisation principale :** analyse des produits et des catégories.

------------------------------------------------------------------------

### 4. `olist_customer_dataset`

Contient les informations géographiques des clients :

-   identifiant du client ;
-   ville ;
-   ..

**Utilisation principale :** analyse client et géographique.

------------------------------------------------------------------------

### 5. `olist_order_reviews_dataset`

Contient les informations relatives aux reviews :

- review_id
- order_id
- review_score
- review_comment_title

**Utilisation principale :** analyse de la satisfaction client.

------------------------------------------------------------------------

### 6. `olist_sellers_dataset`

Contient les informations relatives aux vendeurs :

-   identifiant du vendeur ;
-   ville ;
-   État.

**Utilisation principale :** analyse des vendeurs et de leur
localisation.
------------------------------------------------------------------------

# 6. Tables écartées

Deux tables sont volontairement exclues du périmètre analytique.

## 6.1 `olist_geolocation_dataset`

### Justification

Cette table contient d'enregistrements géographiques
et ajoute un volume important de données qui n'est pas nécessaire pour
les KPI définis dans le projet.

Les tables clients et vendeurs fournissent déjà les informations de
ville et d'État nécessaires à l'analyse géographique.

------------------------------------------------------------------------

## 6.2 `olist_order_payments_dataset`

### Justification

Les informations relatives aux paiements sont en dehors du périmètre des
questions métier définies et n'apportent pas de valeur directe aux KPI
retenus pour :

-   la performance des produits ;
-   l'intelligence client ;
-   la logistique et les opérations.


------------------------------------------------------------------------

# 8. Modélisation du Data Warehouse

Le projet utilise un **schéma en étoile (Star Schema)**.

L'objectif est d'organiser les données analytiques autour :

-   d'une table de faits centrale ;
-   de plusieurs tables de dimensions.

## 8.1 Table de faits

### `fact_sales`

La table de faits contient les informations transactionnelles
nécessaires aux analyses commerciales.

Les informations attendues comprennent notamment :

-   `order_id`
-   `order_item_id`
-   `product_id`
-   `seller_id`
-   `customer_id`
-   informations relatives aux dates
-   `price`
-   `freight_value`
-   `review_score`

------------------------------------------------------------------------

## 8.2 Tables de dimensions

### `dim_customers`

Contient les attributs descriptifs et géographiques des clients.

### `dim_products`

Contient les attributs relatifs aux produits et aux catégories.

### `dim_sellers`

Contient les attributs relatifs aux vendeurs et à leur localisation.

### `dim_date`

Fournit une dimension calendrier réutilisable pour les analyses
temporelles.

------------------------------------------------------------------------

## 8.3 Modèle conceptuel

``` text
                    dim_date
                       │
                       │
                       ▼
dim_customers ──── fact_sales ──── dim_products
                       │
                       │
                       ▼
                  dim_sellers
```

Le modèle physique sera implémenté dans SQL Server puis exploité par
Power BI.

------------------------------------------------------------------------

#9. Technologies utilisées

  Technologie   Utilisation
  ------------- --------------------------------------------------
  Python        Exploration et analyse des données
  Pandas        Manipulation des données et EDA
  SQL Server    Stockage et transformation des données
  SQL           Contrôle qualité, modélisation et calcul des KPI
  Power BI      Reporting et visualisation interactive
  Git           Gestion des versions
  GitHub        Documentation et portfolio

------------------------------------------------------------------------

# 10. Structure du projet

La structure du dépôt reste volontairement simple et réaliste pour un
projet individuel de portfolio.

``` text
Olist-Ecommerce-Analytics/
│
├── README.md
├── 00_project_planning.md
├── .gitignore
├── requirements.txt
│
├── data/
│   └── raw/
│       ├── olist_orders_dataset.csv
│       ├── olist_order_items_dataset.csv
│       ├── olist_products_dataset.csv
│       ├── olist_order_customer_dataset.csv
│       ├── olist_order_reviews_dataset.csv
│       └── olist_sellers_dataset.csv
│
├── notebooks/
│   └── 01_exploratory_analysis.ipynb
│
├── sql/
│   ├── 01_create_staging.sql
│   ├── 02_data_quality.sql
│   ├── 03_star_schema.sql
│   ├── 04_load_datawarehouse.sql
│   └── 05_business_kpis.sql
│
├── powerbi/
│   └── Olist_Ecommerce_Analytics.pbix
│
└── docs/
    ├── data_model.png
    └── data_quality_report.md
```

