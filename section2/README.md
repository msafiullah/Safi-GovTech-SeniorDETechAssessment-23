# E-commerce Data Model

- A total of 18 tables are created to support the e-commerce website application.
- Refer to ER diagram `ecom-er-diagram.png`

## About the tables
- Data about e-commerce website members (i.e. users / customers)
	- users
	- customer_address
- Data about manufacturers
	- manufacturer
- Data about products
	- products
	- product_category
	- product_inventory
- Data about product review by members or anonymous users
	- product_review
- Data about product statistics
	- product_price_history
	- product_impressions
	- product_stats
- Data about web session and shopping cart
	- sessions
	- shopping_cart
- Data about orders (i.e purchase transactions)
	- orders
	- order_details
	- payment_details
	- shipment
- Data about promotions and vouchers
	- promotion
	- vouchers

## Setup Docker

Build postgres image using `Dockerfile` in current directory with the tag `gt-postgres-db`.
```
docker build --tag gt-postgres-db ./
```

Run container in detached mode using configs in `docker-compose.yml`.
```
docker-compose up --detach
```


## Connect to postgresql

1. Connect to docker container that runs postgres db.

2. Connect to `ecom` database.

```
psql -U gtuser -W -d ecom
Password: gtpassword
```

3. Check list of tables in `ecom` database
```
ecom=# \dt
```

 Schema |         Name          | Type  | Owner 
--------|-----------------------|-------|--------
 public | customer_address      | table | gtuser
 public | manufacturer          | table | gtuser
 public | order_details         | table | gtuser
 public | orders                | table | gtuser
 public | payment_details       | table | gtuser
 public | product_category      | table | gtuser
 public | product_impressions   | table | gtuser
 public | product_inventory     | table | gtuser
 public | product_price_history | table | gtuser
 public | product_review        | table | gtuser
 public | product_stats         | table | gtuser
 public | products              | table | gtuser
 public | promotion             | table | gtuser
 public | sessions              | table | gtuser
 public | shipment              | table | gtuser
 public | shopping_cart         | table | gtuser
 public | users                 | table | gtuser
 public | vouchers              | table | gtuser
(18 rows)
