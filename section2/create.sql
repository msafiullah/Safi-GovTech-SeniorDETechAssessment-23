
-- Data about e-commerce website members (i.e. users / customers)

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	member_id TEXT NOT NULL ,
	first_name TEXT NOT NULL ,
	last_name TEXT NOT NULL ,
	mobile_no TEXT ,
	email TEXT ,
	dob DATE ,
	status TEXT ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( member_id )
);

DROP TABLE IF EXISTS customer_address;
CREATE TABLE customer_address (
	address_id BIGINT NOT NULL ,
	member_id TEXT NOT NULL ,
	address_line_1 TEXT ,
	address_line_2 TEXT ,
	postal_code TEXT ,
	city TEXT ,
	country TEXT ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( address_id )
);




-- Data about manufacturers

DROP TABLE IF EXISTS manufacturer;
CREATE TABLE manufacturer (
	manuf_id BIGINT NOT NULL ,
	manuf_name TEXT ,
	phone TEXT ,
	email TEXT ,
	address_line_1 TEXT ,
	address_line_2 TEXT ,
	postal_code TEXT ,
	city TEXT ,
	country TEXT ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( manuf_id )
);




-- Data about products

DROP TABLE IF EXISTS products;
CREATE TABLE products (
	product_id BIGINT NOT NULL ,
	product_name TEXT ,
	manuf_id BIGINT ,
	unit_price NUMERIC(28, 8) ,
	unit_weight_kg NUMERIC(28, 8) ,
	sku TEXT ,
	category_id BIGINT ,
	image_dir TEXT ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( product_id )
);

DROP TABLE IF EXISTS product_category;
CREATE TABLE product_category (
	category_id BIGINT NOT NULL ,
	category_name TEXT ,
	category_desc TEXT ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( category_id )
);

DROP TABLE IF EXISTS product_inventory;
CREATE TABLE product_inventory (
	product_id BIGINT NOT NULL ,
	quantity BIGINT ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( product_id )
);




-- Data about product review by members or anonymous users
DROP TABLE IF EXISTS product_review;
CREATE TABLE product_review (
	review_id BIGINT NOT NULL ,
	rating NUMERIC(28, 8) ,
	member_id TEXT ,
	product_id BIGINT NOT NULL ,
	comment TEXT ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( review_id )
);




-- Data about product statistics

DROP TABLE IF EXISTS product_price_history;
CREATE TABLE product_price_history (
	product_id BIGINT NOT NULL ,
	price NUMERIC(28, 8) ,
	price_end_timestamp TIMESTAMPTZ ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( product_id, price_end_timestamp )
);

DROP TABLE IF EXISTS product_impressions;
CREATE TABLE product_impressions (
	member_id TEXT ,
	product_id BIGINT NOT NULL ,
	session_id BIGINT NOT NULL ,
	event_timestamp TIMESTAMPTZ ,
	event_duration_ms NUMERIC(28, 8) ,
	event_type TEXT ,
	source_traffic_url TEXT ,
	source_traffic_type TEXT ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( product_id, session_id )
);

DROP TABLE IF EXISTS product_stats;
CREATE TABLE product_stats (
	product_id BIGINT NOT NULL ,
	view_cnt BIGINT ,
	order_cnt BIGINT ,
	click_cnt BIGINT ,
	add_to_cart_cnt  BIGINT ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( product_id )
);




-- Data about web session and shopping cart

DROP TABLE IF EXISTS sessions;
CREATE TABLE sessions (
	session_id BIGINT NOT NULL ,
	user_agent TEXT ,
	device TEXT ,
	ip_address TEXT ,
	session_start_timestamp TIMESTAMPTZ ,
	session_end_timestamp TIMESTAMPTZ ,
	member_id TEXT ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( session_id )
);

DROP TABLE IF EXISTS shopping_cart;
CREATE TABLE shopping_cart (
	cart_id BIGINT NOT NULL ,
	member_id TEXT ,
	product_id BIGINT ,
	quantity BIGINT ,
	unit_price NUMERIC(28, 8) ,
	session_id BIGINT ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( cart_id )
);




-- Data about orders (i.e purchase transactions)

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
	order_id BIGINT NOT NULL ,
	member_id TEXT ,
	order_no TEXT ,
	payment_id BIGINT ,
	order_timestamp TIMESTAMPTZ ,
	address_id BIGINT ,
	status TEXT ,
	total_price NUMERIC(28, 8) ,
	total_weight_kg NUMERIC(28, 8) ,
	total_item_quantity BIGINT ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( order_id )
);

DROP TABLE IF EXISTS order_details;
CREATE TABLE order_details (
	order_id BIGINT NOT NULL ,
	product_id BIGINT ,
	order_no TEXT ,
	unit_price NUMERIC(28, 8) ,
	unit_weight_kg NUMERIC(28, 8) ,
	quantity BIGINT ,
	sku TEXT ,
	status TEXT ,
	return_id BIGINT ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( order_id, product_id )
);

DROP TABLE IF EXISTS payment_details;
CREATE TABLE payment_details (
	payment_id BIGINT NOT NULL ,
	order_id BIGINT NOT NULL ,
	amount NUMERIC(28, 8) ,
	provider TEXT ,
	status TEXT ,
	type TEXT ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( payment_id )
);

DROP TABLE IF EXISTS shipment;
CREATE TABLE shipment (
	shipping_id BIGINT NOT NULL ,
	order_id BIGINT ,
	address_id BIGINT ,
	tracking_no TEXT ,
	status TEXT ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( shipping_id )
);




-- Data about promotions and vouchers

DROP TABLE IF EXISTS promotion;
CREATE TABLE promotion (
	promotion_id BIGINT NOT NULL ,
	promotion_desc TEXT ,
	product_id BIGINT ,
	voucher_id BIGINT ,
	status TEXT ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( promotion_id )
);

DROP TABLE IF EXISTS vouchers;
CREATE TABLE vouchers (
	voucher_id BIGINT NOT NULL ,
	promotion_id  BIGINT NOT NULL ,
	voucher_code TEXT NOT NULL ,
	discount_rate  NUMERIC(28, 8) ,
	status TEXT ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( voucher_id )
);



-- Add Foreign Key constraints for all tables

ALTER TABLE    customer_address       DROP CONSTRAINT fk____customer_address____users ;
ALTER TABLE    customer_address        ADD CONSTRAINT fk____customer_address____users           FOREIGN KEY ( member_id )       REFERENCES  users ( member_id )                 ;

ALTER TABLE    payment_details        DROP CONSTRAINT fk____payment_details____orders ;
ALTER TABLE    payment_details         ADD CONSTRAINT fk____payment_details____orders           FOREIGN KEY ( order_id )        REFERENCES  orders ( order_id )                 ;

ALTER TABLE    orders                 DROP CONSTRAINT fk____orders____users ;
ALTER TABLE    orders                  ADD CONSTRAINT fk____orders____users                     FOREIGN KEY ( member_id )       REFERENCES  users ( member_id )                 ;

ALTER TABLE    orders                 DROP CONSTRAINT fk____orders____payment_details ;
ALTER TABLE    orders                  ADD CONSTRAINT fk____orders____payment_details           FOREIGN KEY ( payment_id )      REFERENCES  payment_details ( payment_id )      ;

ALTER TABLE    order_details          DROP CONSTRAINT fk____order_details____orders ;
ALTER TABLE    order_details           ADD CONSTRAINT fk____order_details____orders             FOREIGN KEY ( order_id )        REFERENCES  orders ( order_id )                 ;

ALTER TABLE    order_details          DROP CONSTRAINT fk____order_details____products ;
ALTER TABLE    order_details           ADD CONSTRAINT fk____order_details____products           FOREIGN KEY ( product_id )      REFERENCES  products ( product_id )             ;

ALTER TABLE    product_impressions    DROP CONSTRAINT fk____product_impressions____users ;
ALTER TABLE    product_impressions     ADD CONSTRAINT fk____product_impressions____users        FOREIGN KEY ( product_id )      REFERENCES  users ( product_id )                ;

ALTER TABLE    product_impressions    DROP CONSTRAINT fk____product_impressions____sessions ;
ALTER TABLE    product_impressions     ADD CONSTRAINT fk____product_impressions____sessions     FOREIGN KEY ( session_id )      REFERENCES  sessions ( session_id )             ;

ALTER TABLE    product_inventory      DROP CONSTRAINT fk____product_inventory____products ;
ALTER TABLE    product_inventory       ADD CONSTRAINT fk____product_inventory____products       FOREIGN KEY ( product_id )      REFERENCES  products ( product_id )             ;

ALTER TABLE    product_price_history  DROP CONSTRAINT fk____product_price_history____products ;
ALTER TABLE    product_price_history   ADD CONSTRAINT fk____product_price_history____products   FOREIGN KEY ( product_id )      REFERENCES  products ( product_id )             ;

ALTER TABLE    product_review         DROP CONSTRAINT fk____product_review____users ;
ALTER TABLE    product_review          ADD CONSTRAINT fk____product_review____users             FOREIGN KEY ( member_id )       REFERENCES  users ( member_id )                 ;

ALTER TABLE    product_review         DROP CONSTRAINT fk____product_review____products ;
ALTER TABLE    product_review          ADD CONSTRAINT fk____product_review____products          FOREIGN KEY ( product_id )      REFERENCES  products ( product_id )             ;

ALTER TABLE    product_stats          DROP CONSTRAINT fk____product_stats____products ;
ALTER TABLE    product_stats           ADD CONSTRAINT fk____product_stats____products           FOREIGN KEY ( product_id )      REFERENCES  products ( product_id )             ;

ALTER TABLE    products               DROP CONSTRAINT fk____products____manufacturer ;
ALTER TABLE    products                ADD CONSTRAINT fk____products____manufacturer            FOREIGN KEY ( manuf_id )        REFERENCES  manufacturer ( manuf_id )           ;

ALTER TABLE    products               DROP CONSTRAINT fk____products____product_category ;
ALTER TABLE    products                ADD CONSTRAINT fk____products____product_category        FOREIGN KEY ( category_id )     REFERENCES  product_category ( category_id )    ;

ALTER TABLE    sessions               DROP CONSTRAINT fk____sessions____users ;
ALTER TABLE    sessions                ADD CONSTRAINT fk____sessions____users                   FOREIGN KEY ( member_id )       REFERENCES  users ( member_id )                 ;

ALTER TABLE    shipment               DROP CONSTRAINT fk____shipment____orders ;
ALTER TABLE    shipment                ADD CONSTRAINT fk____shipment____orders                  FOREIGN KEY ( order_id )        REFERENCES  orders ( order_id )                 ;

ALTER TABLE    shipment               DROP CONSTRAINT fk____shipment____customer_address ;
ALTER TABLE    shipment                ADD CONSTRAINT fk____shipment____customer_address        FOREIGN KEY ( address_id )      REFERENCES  customer_address ( address_id )     ;

ALTER TABLE    shopping_cart          DROP CONSTRAINT fk____shopping_cart____users ;
ALTER TABLE    shopping_cart           ADD CONSTRAINT fk____shopping_cart____users              FOREIGN KEY ( member_id )       REFERENCES  users ( member_id )                 ;

ALTER TABLE    shopping_cart          DROP CONSTRAINT fk____shopping_cart____products ;
ALTER TABLE    shopping_cart           ADD CONSTRAINT fk____shopping_cart____products           FOREIGN KEY ( product_id )      REFERENCES  products ( product_id )             ;

ALTER TABLE    shopping_cart          DROP CONSTRAINT fk____shopping_cart____sessions ;
ALTER TABLE    shopping_cart           ADD CONSTRAINT fk____shopping_cart____sessions           FOREIGN KEY ( session_id )      REFERENCES  sessions ( session_id )             ;

ALTER TABLE    promotion              DROP CONSTRAINT fk____promotion____products ;
ALTER TABLE    promotion               ADD CONSTRAINT fk____promotion____products               FOREIGN KEY ( product_id )      REFERENCES  products ( product_id )             ;

ALTER TABLE    promotion              DROP CONSTRAINT fk____promotion____vouchers ;
ALTER TABLE    promotion               ADD CONSTRAINT fk____promotion____vouchers               FOREIGN KEY ( voucher_id )      REFERENCES  vouchers ( voucher_id )             ;

ALTER TABLE    vouchers               DROP CONSTRAINT fk____vouchers____promotion ;
ALTER TABLE    vouchers                ADD CONSTRAINT fk____vouchers____promotion               FOREIGN KEY ( promotion_id )    REFERENCES  promotion ( promotion_id )          ;
