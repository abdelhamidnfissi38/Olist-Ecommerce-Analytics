# Olist E-Commerce Analytics — Planification du projet

## 1. Vue d'ensemble du projet

### 1.1 Titre du projet

**Olist E-Commerce Analytics : Intelligence Produits, Clients et Logistique**

### 1.2 Type de projet

Projet **Data Analytics & Business Intelligence de bout en bout**, basé sur le jeu de données public Olist E-Commerce.

### 1.3 Objectif du projet

Ce projet vise à analyser les données e-commerce d'Olist afin de produire des informations exploitables autour de trois domaines principaux :

- **Performance des produits**
- **Intelligence client**
- **Logistique et opérations**

Le projet suit un flux analytique complet :

```text
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

---

# 2. Contexte métier

Olist est une plateforme e-commerce brésilienne mettant en relation des clients et des vendeurs.

L'objectif de cette analyse est d'aider l'entreprise à mieux comprendre :

- quels produits et quelles catégories sont les plus et les moins performants ;
- quelles zones géographiques génèrent le plus d'activité ;
- comment se comporte la fréquence d'achat des clients ;
- comment la performance des livraisons influence la satisfaction client ;
- si les retards de livraison ont un impact sur l'expérience client.

Le résultat final sera un **tableau de bord Power BI orienté métier**, alimenté par SQL Server et reposant sur un modèle de données en **schéma en étoile**.

---

# 3. Questions métier

Le projet doit répondre aux questions suivantes.

## 3.1 Performance des produits

- Quels produits génèrent le chiffre d'affaires le plus élevé ?
- Quels produits présentent le plus grand volume de ventes ?
- Quels produits sont les moins performants ?
- Quelles catégories génèrent le plus et le moins de chiffre d'affaires ?
- Existe-t-il une relation entre le poids d'un produit et sa performance commerciale ?
- Le poids du produit influence-t-il les frais de livraison ?
- Quels produits très vendus génèrent également des frais de livraison élevés ?

## 3.2 Intelligence client et géographique

- Quelles villes et quels États génèrent le plus de commandes ?
- Quelles villes et quels États génèrent le plus de chiffre d'affaires ?
- Quelles zones géographiques sont les moins performantes ?
- Quel est l'impact de la performance de livraison sur la note attribuée par le client ?
- Quel pourcentage de clients effectuent plus d'une commande ?

## 3.3 Logistique et opérations

- Quel pourcentage des commandes est livré à temps ?
- Quel pourcentage des commandes est livré en retard ?
- Quel est le délai moyen de livraison ?
- Les retards de livraison sont-ils associés à une satisfaction client plus faible ?

---

# 4. Indicateurs clés de performance (KPI)

Le projet se concentre sur les KPI suivants.

## A. Performance des produits

### Top & Bottom Products

Identifier :

- les 10 produits générant le plus de chiffre d'affaires ;
- les 10 produits générant le moins de chiffre d'affaires ;
- les 10 produits ayant le plus grand volume de ventes ;
- les 10 produits ayant le plus faible volume de ventes.

### Meilleures et moins bonnes catégories

Identifier les catégories générant :

- le chiffre d'affaires le plus élevé ;
- le chiffre d'affaires le plus faible.

### Analyse Poids vs Ventes

Analyser la relation entre :

- `product_weight_g` ;
- le volume des ventes ;
- `freight_value`.

### Produits à fort volume et frais de livraison élevés

Identifier les produits qui :

- présentent un volume de ventes élevé ;
- génèrent également des frais de livraison (`freight_value`) élevés.

L'objectif est d'identifier les produits performants commercialement mais susceptibles de générer des coûts logistiques importants.

---

## B. Intelligence client et géographique

### Top & Bottom Cities / States

Identifier les villes et États les plus et les moins performants selon :

- le nombre de commandes ;
- le chiffre d'affaires.

### Livraison vs Note client

Analyser la relation entre :

- la performance de livraison ;
- la note attribuée par le client.

L'objectif est de déterminer si les commandes livrées en retard sont associées à une satisfaction client plus faible.

Cette analyse sera effectuée au **niveau commande (`order_id`)**, car les évaluations clients sont associées aux commandes et non directement aux produits.

### Taux de réachat

Calculer le pourcentage de clients ayant effectué plus d'une commande.

---

## C. Logistique et opérations

### Taux de livraison à temps

Pourcentage des commandes pour lesquelles :

```text
Date de livraison réelle <= Date de livraison estimée
```

### Taux de livraison en retard

Pourcentage des commandes pour lesquelles :

```text
Date de livraison réelle > Date de livraison estimée
```

### Délai moyen de livraison

Calculer le nombre moyen de jours entre la date d'achat et la date de livraison réelle.

---

# 5. Périmètre des données

Le périmètre du projet repose sur **8 tables relationnelles considérées dans le cadrage**, dont **6 sont conservées** et **2 sont volontairement écartées**.

## 5.1 Tables conservées

### 1. `olist_orders_dataset`

Contient les informations au niveau de la commande, notamment :

- identifiant de la commande ;
- statut de la commande ;
- date d'achat ;
- date d'approbation ;
- date de remise au transporteur ;
- date de livraison estimée ;
- date de livraison réelle.

**Utilisation principale :** analyse du cycle de vie des commandes et de la livraison.

---

### 2. `olist_order_items_dataset`

Contient les informations transactionnelles au niveau de l'article :

- identifiant de la commande ;
- identifiant de l'article dans la commande ;
- identifiant du produit ;
- identifiant du vendeur ;
- prix ;
- frais de livraison.

**Utilisation principale :** analyse des ventes et de la performance des produits.

---

### 3. `olist_products_dataset`

Contient les caractéristiques des produits :

- identifiant du produit ;
- catégorie du produit ;
- poids du produit ;
- dimensions physiques.

**Utilisation principale :** analyse des produits, des catégories et de la relation entre caractéristiques physiques et performance commerciale.

---

### 4. `olist_customer_dataset`

Contient les informations relatives aux clients :

- `customer_id` ;
- `customer_unique_id` ;
- ville ;
- État ;
- préfixe du code postal.

**Utilisation principale :** analyse client, géographique et calcul du taux de réachat.

---

### 5. `olist_order_reviews_dataset`

Contient les informations relatives aux évaluations :

- `review_id` ;
- `order_id` ;
- `review_score` ;
- commentaires ;
- dates liées à l'évaluation.

**Utilisation principale :** analyse de la satisfaction client et de la relation entre livraison et note attribuée.

Les évaluations restent analysées au **niveau commande** afin d'éviter d'attribuer une note de commande directement à un produit spécifique.

---

### 6. `olist_sellers_dataset`

Contient les informations relatives aux vendeurs :

- identifiant du vendeur ;
- ville ;
- État ;
- préfixe du code postal.

**Utilisation principale :** analyse descriptive des vendeurs et de leur localisation.

---

# 6. Tables écartées

Deux tables sont volontairement exclues du périmètre analytique.

## 6.1 `olist_geolocation_dataset`

### Justification

Cette table contient un volume important d'enregistrements géographiques qui n'est pas nécessaire pour les KPI définis dans ce projet.

Les tables clients et vendeurs fournissent déjà les informations de ville et d'État nécessaires à l'analyse géographique retenue.

---

## 6.2 `olist_order_payments_dataset`

### Justification

Les informations relatives aux paiements sont en dehors du périmètre des questions métier définies et n'apportent pas de valeur directe aux KPI retenus pour :

- la performance des produits ;
- l'intelligence client ;
- la logistique et les opérations.

---

# 7. Architecture des données

```text
Données CSV Olist
        ↓
Python / Pandas
Exploration des données
        ↓
SQL Server
Schéma staging
        ↓
Contrôle qualité
        ↓
Nettoyage et transformation lors du chargement
        ↓
Data Warehouse
Schéma en étoile
        ↓
Analyse SQL des KPI
        ↓
Power BI
```

Le schéma `staging` conserve les données proches de la source.

Les anomalies détectées dans `02_data_quality.sql` sont traitées lors du chargement vers le Data Warehouse dans `04_load_datawarehouse.sql`.

---

# 8. Modélisation du Data Warehouse

Le projet utilise un **schéma en étoile (Star Schema)**.

L'objectif est d'organiser les données analytiques autour :

- d'une table de faits centrale ;
- de plusieurs tables de dimensions.

## 8.1 Table de faits

### `fact_sales`

La table `fact_sales` représente les ventes au niveau article.

**Grain :**

> Une ligne représente un article vendu dans une commande.

Les principales informations contenues sont :

- `order_id`
- `order_item_id`
- `product_key`
- `customer_key`
- `seller_key`
- `purchase_date_key`
- `price`
- `freight_value`
- `order_status`
- `order_delivered_customer_date`
- `order_estimated_delivery_date`

La table est principalement construite à partir de `staging.order_items`, puis enrichie avec les informations nécessaires provenant de `staging.orders` et des dimensions.

Les données de review ne sont pas stockées directement dans `fact_sales`, car elles sont associées au niveau commande et non au niveau article.

---

## 8.2 Tables de dimensions

### `dim_customers`

Contient les attributs descriptifs et géographiques des clients.

**Grain :** une ligne = un `customer_id`.

Principales informations :

- `customer_key`
- `customer_id`
- `customer_unique_id`
- `customer_zip_code_prefix`
- `customer_city`
- `customer_state`

### `dim_products`

Contient les attributs relatifs aux produits.

**Grain :** une ligne = un produit.

Principales informations :

- `product_key`
- `product_id`
- `product_category_name`
- `product_weight_g`
- `product_length_cm`
- `product_height_cm`
- `product_width_cm`

### `dim_sellers`

Contient les attributs relatifs aux vendeurs et à leur localisation.

**Grain :** une ligne = un vendeur.

Principales informations :

- `seller_key`
- `seller_id`
- `seller_zip_code_prefix`
- `seller_city`
- `seller_state`

### `dim_date`

Dimension calendrier créée principalement à partir de `order_purchase_timestamp`.

**Grain :** une ligne = une date.

Principales informations :

- `date_key`
- `full_date`
- `day`
- `month`
- `month_name`
- `quarter`
- `year`

---

## 8.3 Modèle conceptuel

```text
                    dim_date
                       │
                       ▼
dim_customers ──── fact_sales ──── dim_products
                       │
                       ▼
                  dim_sellers
```

Le modèle physique est implémenté dans SQL Server puis exploité par Power BI.

Les analyses liées aux évaluations clients utilisent `staging.reviews` avec les données de commande au niveau `order_id`, afin de respecter la granularité des évaluations.

---

# 9. Technologies utilisées

| Technologie | Utilisation |
|---|---|
| Python | Exploration et analyse des données |
| Pandas | Manipulation des données et EDA |
| SQL Server | Stockage, transformation et Data Warehouse |
| SQL | Contrôle qualité, modélisation et calcul des KPI |
| Power BI | Reporting et visualisation interactive |
| Git | Gestion des versions |
| GitHub | Documentation et portfolio |

---

# 10. Structure du projet

```text
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

---

# 11. Plan d'exécution

## Phase 1 — Compréhension métier

Définir le contexte métier, les objectifs, les questions métier, les KPI et le périmètre des données.

**Livrable :**

```text
00_project_planning.md
```

## Phase 2 — Exploration des données

Utiliser Python et Pandas pour comprendre les six tables conservées.

Principales tâches :

- charger les fichiers CSV ;
- examiner la structure des tables ;
- vérifier les types de données ;
- identifier les valeurs manquantes ;
- identifier les clés candidates ;
- déterminer le grain des tables ;
- vérifier les relations entre les tables.

**Livrable :**

```text
notebooks/01_exploratory_analysis.ipynb
```

## Phase 3 — Staging dans SQL Server

Créer et charger les six tables de staging :

```text
staging.orders
staging.order_items
staging.products
staging.customers
staging.reviews
staging.sellers
```

Le staging reste aussi proche que possible des données sources.

**Livrable :**

```text
sql/01_create_staging.sql
```

## Phase 4 — Contrôle qualité des données

Effectuer les contrôles suivants :

- valeurs manquantes ;
- doublons ;
- valeurs invalides ;
- dates incohérentes ;
- types de données incohérents ;
- intégrité référentielle ;
- cohérence avec les règles métier.

**Livrables :**

```text
sql/02_data_quality.sql
docs/data_quality_report.md
```

## Phase 5 — Création du Star Schema

Créer :

```text
dw.dim_products
dw.dim_customers
dw.dim_sellers
dw.dim_date
dw.fact_sales
```

**Livrable :**

```text
sql/03_star_schema.sql
```

## Phase 6 — Nettoyage, transformation et chargement du Data Warehouse

Transformer les données du staging en appliquant les décisions issues du contrôle qualité, puis charger les dimensions et `fact_sales`.

Exemples de traitements :

- catégories produit manquantes regroupées sous une valeur contrôlée ;
- poids produit invalides transformés en `NULL` ;
- prise en compte des anomalies chronologiques détectées ;
- conversion des identifiants source vers les clés de substitution des dimensions.

**Livrable :**

```text
sql/04_load_datawarehouse.sql
```

## Phase 7 — Analyse des KPI métier

Implémenter les KPI dans SQL.

Les KPI de ventes et produits utilisent principalement le Data Warehouse.

Les analyses combinant livraison et satisfaction client sont réalisées au niveau `order_id` afin de respecter la granularité des reviews.

**Livrable :**

```text
sql/05_business_kpis.sql
```

---

# 12. Tableau de bord Power BI

Power BI exploitera le modèle analytique construit dans SQL Server.

## Performance des produits

Visualiser :

- les produits les plus et les moins performants ;
- les meilleures et moins bonnes catégories ;
- la relation entre poids et ventes ;
- les produits à fort volume générant des frais de livraison élevés.

## Intelligence client

Visualiser :

- la performance géographique ;
- le comportement d'achat ;
- le taux de réachat ;
- la relation entre livraison et note client.

## Logistique

Visualiser :

- le taux de livraison à temps ;
- le taux de livraison en retard ;
- le délai moyen de livraison ;
- l'impact des retards sur la satisfaction client.

---

# 13. Validation

Avant de finaliser le tableau de bord, les résultats doivent être vérifiés entre SQL Server et Power BI.

Les contrôles doivent notamment porter sur :

- le nombre de lignes de la table de faits ;
- le chiffre d'affaires ;
- les frais de livraison ;
- le nombre de commandes ;
- les indicateurs de livraison ;
- le taux de réachat ;
- les indicateurs liés aux évaluations clients.

---

# 14. Critères de réussite

Le projet sera considéré comme terminé lorsque :

- les six tables sélectionnées sont correctement chargées et analysées ;
- les deux tables exclues sont documentées et leur exclusion est justifiée ;
- les problèmes de qualité des données sont identifiés et documentés ;
- les anomalies nécessaires sont traitées pendant le chargement du Data Warehouse ;
- le schéma en étoile est implémenté dans SQL Server ;
- les dimensions et `fact_sales` sont correctement alimentées ;
- les mesures financières sont cohérentes entre le staging et le Data Warehouse ;
- tous les KPI définis dans ce document sont calculés ;
- les résultats SQL sont validés ;
- le tableau de bord Power BI présente les analyses métier prévues ;
- le dépôt GitHub est clairement documenté et présentable dans un portfolio.
