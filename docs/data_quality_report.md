# Rapport de qualité des données — Olist E-Commerce Analytics

## 1. Objectif

Ce document présente les résultats des contrôles de qualité appliqués aux six tables chargées dans le schéma `staging` de SQL Server.

L’objectif est de vérifier que les données sont suffisamment fiables avant la construction du Data Warehouse en schéma en étoile et le calcul des KPI dans Power BI.

Les contrôles portent sur :

- les valeurs manquantes ;
- les doublons ;
- les valeurs invalides ;
- les incohérences de dates ;
- les types de données ;
- l’intégrité référentielle ;
- les règles métier.

---

# 2. Valeurs manquantes

## 2.1 `orders`

Valeurs manquantes détectées :

| Colonne | Nombre de NULL |
|---|---:|
| `order_approved_at` | 160 |
| `order_delivered_carrier_date` | 1 783 |
| `order_delivered_customer_date` | 2 965 |

Certaines valeurs manquantes sont cohérentes avec le cycle de vie d’une commande, notamment pour les commandes annulées, non disponibles ou non encore livrées.

En revanche, certains cas sont incohérents avec le statut `delivered` et sont détaillés dans la section sur les règles métier.

## 2.2 `order_items`

Aucune valeur manquante détectée.

## 2.3 `products`

Valeurs manquantes détectées :

| Colonne | Nombre de NULL |
|---|---:|
| `product_category_name` | 610 |
| `product_name_lenght` | 610 |
| `product_description_lenght` | 610 |
| `product_photos_qty` | 610 |
| `product_weight_g` | 2 |
| `product_length_cm` | 2 |
| `product_height_cm` | 2 |
| `product_width_cm` | 2 |

Les 610 valeurs manquantes concernant la catégorie, la longueur du nom, la longueur de la description et le nombre de photos correspondent aux mêmes produits.

## 2.4 `customers`

Aucune valeur manquante détectée.

## 2.5 `reviews`

Les colonnes critiques (`review_id`, `order_id`, `review_score`, dates) sont renseignées.

Les colonnes `review_comment_title` et `review_comment_message` contiennent des valeurs manquantes, mais celles-ci sont considérées comme acceptables : un client peut attribuer une note sans laisser de commentaire.

## 2.6 `sellers`

Aucune valeur manquante détectée.

---

# 3. Doublons

Les doublons ont été contrôlés selon les clés logiques identifiées pendant l’analyse exploratoire.

| Table | Clé logique contrôlée | Résultat |
|---|---|---|
| `orders` | `order_id` | Aucun doublon |
| `order_items` | `order_id`, `order_item_id` | Aucun doublon |
| `products` | `product_id` | Aucun doublon |
| `customers` | `customer_id` | Aucun doublon |
| `reviews` | `review_id`, `order_id` | Aucun doublon |
| `sellers` | `seller_id` | Aucun doublon |

Les grains identifiés pendant l’EDA sont donc respectés dans le staging.

---

# 4. Valeurs invalides

## 4.1 `order_items`

Règles contrôlées :

- `price >= 0`
- `freight_value >= 0`

Résultat : aucune valeur négative détectée.

## 4.2 `reviews`

Règle contrôlée :

- `review_score` compris entre 1 et 5.

Résultat : tous les scores sont valides.

## 4.3 `products`

Règles contrôlées :

- `product_weight_g > 0`
- `product_length_cm > 0`
- `product_height_cm > 0`
- `product_width_cm > 0`

Résultat :

- 4 produits ont `product_weight_g = 0`.

Ces valeurs sont considérées comme invalides pour l’analyse **Weight vs. Sales**.

---

# 5. Incohérences chronologiques

Les principales règles de cohérence temporelle ont été contrôlées sur la table `orders`.

| Contrôle | Résultat |
|---|---:|
| `order_approved_at < order_purchase_timestamp` | 0 |
| `order_delivered_carrier_date < order_purchase_timestamp` | 166 |
| `order_delivered_customer_date < order_delivered_carrier_date` | 23 |
| `order_delivered_customer_date < order_purchase_timestamp` | 0 |
| `order_estimated_delivery_date < order_purchase_timestamp` | 0 |

Deux types d’anomalies chronologiques ont donc été détectés :

- 166 commandes ont une date de remise au transporteur antérieure à la date d’achat ;
- 23 commandes ont une date de livraison client antérieure à la date de remise au transporteur.

---

# 6. Types de données

Les types ont été contrôlés dans le schéma `staging` via `INFORMATION_SCHEMA.COLUMNS`.

Les principaux types utilisés sont cohérents avec la nature des données :

- identifiants : `VARCHAR` ;
- dates et horodatages : `DATETIME2` ;
- montants : `DECIMAL` ;
- compteurs et identifiants numériques : `INT`.

Aucune incohérence de type importante n’a été détectée après le chargement.

---

# 7. Intégrité référentielle

Les relations suivantes ont été contrôlées :

- `order_items.order_id` → `orders.order_id`
- `order_items.product_id` → `products.product_id`
- `order_items.seller_id` → `sellers.seller_id`
- `orders.customer_id` → `customers.customer_id`
- `reviews.order_id` → `orders.order_id`

Résultat :

**aucune référence orpheline détectée.**

L’intégrité référentielle entre les six tables du staging est donc respectée.

---

# 8. Cohérence avec les règles métier

Les commandes ayant le statut `delivered` ont fait l’objet de contrôles supplémentaires.

Anomalies détectées :

| Règle métier | Nombre de lignes |
|---|---:|
| Commande `delivered` sans `order_delivered_customer_date` | 8 |
| Commande `delivered` sans `order_delivered_carrier_date` | 2 |
| Commande `delivered` sans `order_approved_at` | 14 |

Ces cas sont incohérents avec le cycle de vie attendu d’une commande livrée.

---

# 9. Synthèse des anomalies

Les principales anomalies identifiées sont :

1. des valeurs manquantes dans certaines dates de commande ;
2. des métadonnées produit manquantes pour 610 produits ;
3. 2 produits avec certaines caractéristiques physiques manquantes ;
4. 4 produits avec un poids égal à 0 ;
5. 166 incohérences entre date d’achat et remise au transporteur ;
6. 23 incohérences entre remise au transporteur et livraison client ;
7. quelques commandes `delivered` avec des dates opérationnelles manquantes.

Certaines anomalies peuvent concerner les mêmes lignes. Les nombres ci-dessus ne doivent donc pas être additionnés pour obtenir un total d’enregistrements problématiques.

---

# 10. Conclusion

La qualité globale des données est satisfaisante pour poursuivre le projet :

- aucune duplication détectée sur les clés logiques ;
- aucune rupture d’intégrité référentielle ;
- prix et frais de livraison valides ;
- scores d’évaluation valides ;
- types de données cohérents dans SQL Server.

Cependant, plusieurs anomalies doivent être traitées ou prises en compte avant le chargement du Data Warehouse, notamment celles qui concernent :

- les dates incohérentes ;
- les commandes livrées avec des dates manquantes ;
- les poids de produits invalides ;
- les métadonnées produit manquantes.

Les décisions de traitement seront appliquées avant ou pendant le chargement des données dans le schéma en étoile.
