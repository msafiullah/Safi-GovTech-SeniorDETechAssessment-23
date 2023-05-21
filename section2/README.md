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

## SQL Task Answers

#### 1. Which are the top 10 members by spending

**1A. Query top 10 members by spending.**
```
select member_id, sum(total_price) as total_spending
from orders
where is_test_data != 1 and is_deleted != 1
group by member_id
order by sum(total_price) desc
limit 10
;
```

**1B. Query top 10 members by spending, with their user info.**
```
with 

top10_members_by_spending as (
    select member_id, sum(total_price) as total_spending
    from orders
    where is_test_data != 1 and is_deleted != 1
    group by member_id
    order by sum(total_price) desc
    limit 10
), 

user_info as (
    select *
    from users
    where is_test_data != 1 and is_deleted != 1
)

select 
    t.member_id
    , t.total_spending
    , u.first_name
    , u.last_name
    , u.mobile_no
    , u.email
    , u.dob
from top10_members_by_spending t
join user_info u
    on top10_members_by_spending.member_id = user_info.member_id
;
```

#### 2. Which are the top 3 items that are frequently brought by members

- Assuming "frequently bought" refers to highest quantity of products bought (i.e. purchase transaction completed) by any members.
- Also, order doesn't have to be considered delivered or fullfilled yet fall into this count.
- Potentially returned items are still considered in this count.

**2A. Query top 3 frequently bought products.**
```
select product_id, sum(quantity) as total_quantity_bought
from order_details
where is_test_data != 1 and is_deleted != 1
group by product_id
order by sum(quantity) desc
limit 3
;
```

**2B. Query top 3 frequently bought products, with product and category info.**
```
with 

top3_frequently_bought_products as (
    select product_id, sum(quantity) as total_quantity_bought
    from order_details
    where is_test_data != 1 and is_deleted != 1
    group by product_id
    order by sum(quantity) desc
    limit 3
)

select 
    t.product_id
    , t.total_quantity_bought
    , p.product_name
    , p.unit_weight_kg
    , c.category_name
    , c.category_desc
from top3_frequently_bought_products t
join products as p
    on t.product_id = p.product_id
        and p.is_test_data != 1 and p.is_deleted != 1
left join product_category c
    on p.category_id = c.category_id
        and c.is_test_data != 1 and c.is_deleted != 1
;
```

## Data Analytics Business Use Cases

Here are some interesting analytics use cases that the proposed database design can support.

#### 1. Product statistics
- page visits
- product view count
- product view duratiom
- product click count
- product add to cart count
- product checkout count
- product purchase count
- unique user visits to product details page
- click through rate from product view, add to cart, checkout, purchase, and to return visits.
- bounce rate for product details page
- product rating

#### 2. Order statistics
- return order rate
- repeat order rate
- average items per order
- total number of orders over time
- revenue per order
- revenue after promotion

#### 3. Session statistics
- pages per session
- peak period
- average session duration
- revenue per session
- average number of orders per session
- product views or clicks per session

#### 4. Customer statistics
- conversion rate for repeat visits
- customer lifetime value
- revenue per customer
- voucher usage rate
- accumulated discount
- revenue per visit
- orders per visit
- order return rate

#### 5. Traffic flow statistics
- referral vs direct traffic rate
- click stream analytics
- top referrals
- related products of interest

