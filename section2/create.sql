
-- Data about e-commerce website members (i.e. users / customers)

DROP TABLE IF EXISTS users CASCADE;
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
) PARTITION BY HASH ( member_id );


DROP TABLE IF EXISTS customer_address CASCADE;
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
) PARTITION BY HASH ( address_id );
CREATE INDEX idx_customer_address_member_id ON customer_address USING HASH (member_id);



-- Data about manufacturers

DROP TABLE IF EXISTS manufacturer CASCADE;
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
) PARTITION BY HASH ( manuf_id );
CREATE INDEX idx_manufacturer_manuf_name ON manufacturer USING btree (manuf_name);



-- Data about products

DROP TABLE IF EXISTS products CASCADE;
CREATE TABLE products (
	product_id BIGINT NOT NULL ,
	product_name TEXT ,
	product_desc TEXT ,
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
) PARTITION BY HASH ( product_id );
CREATE INDEX idx_products_manuf_id ON products USING HASH (manuf_id);
CREATE INDEX idx_products_category_id ON products USING HASH (category_id);
CREATE INDEX idx_products_product_name ON products USING btree (product_name);
CREATE INDEX idx_products_product_desc ON products USING btree (product_desc);


DROP TABLE IF EXISTS product_category CASCADE;
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
) PARTITION BY HASH ( category_id );
CREATE INDEX idx_product_category_name ON product_category USING btree (category_name);
CREATE INDEX idx_product_category_desc ON product_category USING btree (category_desc);


DROP TABLE IF EXISTS product_inventory CASCADE;
CREATE TABLE product_inventory (
	product_id BIGINT NOT NULL ,
	quantity BIGINT ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( product_id )
) PARTITION BY HASH ( product_id );



-- Data about product review by members or anonymous users
DROP TABLE IF EXISTS product_review CASCADE;
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
) PARTITION BY HASH ( review_id );
CREATE INDEX idx_product_review_product_id ON product_review USING HASH (product_id);
CREATE INDEX idx_product_review_member_id ON product_review USING HASH (member_id);
CREATE INDEX idx_product_review_rating ON product_review USING btree (rating);



-- Data about product statistics

DROP TABLE IF EXISTS product_price_history CASCADE;
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
) PARTITION BY RANGE ( price_end_timestamp );


DROP TABLE IF EXISTS product_impressions CASCADE;
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
) PARTITION BY HASH ( product_id, session_id );
CREATE INDEX idx_product_impressions_member_id ON product_impressions USING HASH (member_id);
CREATE INDEX idx_product_impressions_event_type ON product_impressions USING HASH (event_type);
CREATE INDEX idx_product_impressions_source_traffic_type ON product_impressions USING HASH (source_traffic_type);
CREATE INDEX idx_product_impressions_event_timestamp ON product_impressions USING btree (event_timestamp);


DROP TABLE IF EXISTS product_stats CASCADE;
CREATE TABLE product_stats (
	record_date DATE NOT NULL ,
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
	
	PRIMARY KEY ( record_date, product_id )
) PARTITION BY RANGE ( record_date );
CREATE INDEX idx_product_stats_record_date ON product_stats USING brin (record_date);



-- Data about web session and shopping cart

DROP TABLE IF EXISTS sessions CASCADE;
CREATE TABLE sessions (
	record_date DATE NOT NULL ,
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
	
	PRIMARY KEY ( record_date, session_id )
) PARTITION BY RANGE ( record_date );

CREATE INDEX idx_sessions_member_id ON sessions USING HASH (member_id);
CREATE INDEX idx_sessions_user_agent ON sessions USING btree (user_agent);
CREATE INDEX idx_sessions_device ON sessions USING btree (device);


DROP TABLE IF EXISTS shopping_cart CASCADE;
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
) PARTITION BY HASH ( cart_id );
CREATE INDEX idx_shopping_cart_member_id ON shopping_cart USING HASH (member_id);



-- Data about orders (i.e purchase transactions)

DROP TABLE IF EXISTS orders CASCADE;
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
) PARTITION BY HASH ( order_id );
CREATE INDEX idx_orders_member_id ON orders USING HASH (member_id);
CREATE INDEX idx_orders_status ON orders USING HASH (status);
CREATE INDEX idx_orders_order_no ON orders USING btree (order_no);


DROP TABLE IF EXISTS order_details CASCADE;
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
) PARTITION BY HASH ( order_id, product_id );

CREATE INDEX idx_order_details_status ON order_details USING HASH (status);
CREATE INDEX idx_order_details_order_no ON order_details USING btree (order_no);

DROP TABLE IF EXISTS vouchers_applied CASCADE;
CREATE TABLE vouchers_applied (
	order_id  BIGINT NOT NULL ,
	voucher_id BIGINT NOT NULL ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( order_id, voucher_id )
) PARTITION BY HASH ( order_id, voucher_id );


DROP TABLE IF EXISTS payment_details CASCADE;
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
) PARTITION BY HASH ( payment_id );
CREATE INDEX idx_payment_details_order_id ON payment_details USING HASH (order_id);
CREATE INDEX idx_payment_details_status ON payment_details USING HASH (status);
CREATE INDEX idx_payment_details_type ON payment_details USING HASH (type);


DROP TABLE IF EXISTS shipment CASCADE;
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
) PARTITION BY HASH ( shipping_id );
CREATE INDEX idx_shipment_order_id ON shipment USING HASH (order_id);
CREATE INDEX idx_shipment_address_id ON shipment USING HASH (address_id);
CREATE INDEX idx_shipment_status ON shipment USING HASH (status);
CREATE INDEX idx_shipment_tracking_no ON shipment USING btree (tracking_no);



-- Data about promotions and vouchers

DROP TABLE IF EXISTS promotion CASCADE;
CREATE TABLE promotion (
	promotion_id BIGINT NOT NULL ,
	promotion_desc TEXT ,
	status TEXT ,
	created_at TIMESTAMPTZ ,
	modified_at TIMESTAMPTZ ,
	deleted_at TIMESTAMPTZ ,
	is_deleted BOOLEAN ,
	is_test_data BOOLEAN ,
	
	PRIMARY KEY ( promotion_id )
) PARTITION BY HASH ( promotion_id );


DROP TABLE IF EXISTS vouchers CASCADE;
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
) PARTITION BY HASH ( voucher_id );
CREATE INDEX idx_vouchers_promotion_id ON vouchers USING HASH (promotion_id);



-- Add Foreign Key constraints for all tables

ALTER TABLE    customer_address       DROP CONSTRAINT IF EXISTS fk____customer_address____users ;
ALTER TABLE    customer_address        ADD CONSTRAINT           fk____customer_address____users           FOREIGN KEY ( member_id )       REFERENCES  users ( member_id )                 ;

ALTER TABLE    payment_details        DROP CONSTRAINT IF EXISTS fk____payment_details____orders ;
ALTER TABLE    payment_details         ADD CONSTRAINT           fk____payment_details____orders           FOREIGN KEY ( order_id )        REFERENCES  orders ( order_id )                 ;

ALTER TABLE    orders                 DROP CONSTRAINT IF EXISTS fk____orders____users ;
ALTER TABLE    orders                  ADD CONSTRAINT           fk____orders____users                     FOREIGN KEY ( member_id )       REFERENCES  users ( member_id )                 ;

ALTER TABLE    orders                 DROP CONSTRAINT IF EXISTS fk____orders____payment_details ;
ALTER TABLE    orders                  ADD CONSTRAINT           fk____orders____payment_details           FOREIGN KEY ( payment_id )      REFERENCES  payment_details ( payment_id )      ;

ALTER TABLE    order_details          DROP CONSTRAINT IF EXISTS fk____order_details____orders ;
ALTER TABLE    order_details           ADD CONSTRAINT           fk____order_details____orders             FOREIGN KEY ( order_id )        REFERENCES  orders ( order_id )                 ;

ALTER TABLE    order_details          DROP CONSTRAINT IF EXISTS fk____order_details____products ;
ALTER TABLE    order_details           ADD CONSTRAINT           fk____order_details____products           FOREIGN KEY ( product_id )      REFERENCES  products ( product_id )             ;

ALTER TABLE    product_impressions    DROP CONSTRAINT IF EXISTS fk____product_impressions____users ;
ALTER TABLE    product_impressions     ADD CONSTRAINT           fk____product_impressions____users        FOREIGN KEY ( member_id )       REFERENCES  users ( member_id )                 ;

ALTER TABLE    product_impressions    DROP CONSTRAINT IF EXISTS fk____product_impressions____products ;
ALTER TABLE    product_impressions     ADD CONSTRAINT           fk____product_impressions____products     FOREIGN KEY ( product_id )      REFERENCES  products ( product_id )             ;

ALTER TABLE    product_impressions    DROP CONSTRAINT IF EXISTS fk____product_impressions____sessions ;
ALTER TABLE    product_impressions     ADD CONSTRAINT           fk____product_impressions____sessions     FOREIGN KEY ( session_id )      REFERENCES  sessions ( session_id )             ;

ALTER TABLE    product_inventory      DROP CONSTRAINT IF EXISTS fk____product_inventory____products ;
ALTER TABLE    product_inventory       ADD CONSTRAINT           fk____product_inventory____products       FOREIGN KEY ( product_id )      REFERENCES  products ( product_id )             ;

ALTER TABLE    product_price_history  DROP CONSTRAINT IF EXISTS fk____product_price_history____products ;
ALTER TABLE    product_price_history   ADD CONSTRAINT           fk____product_price_history____products   FOREIGN KEY ( product_id )      REFERENCES  products ( product_id )             ;

ALTER TABLE    product_review         DROP CONSTRAINT IF EXISTS fk____product_review____users ;
ALTER TABLE    product_review          ADD CONSTRAINT           fk____product_review____users             FOREIGN KEY ( member_id )       REFERENCES  users ( member_id )                 ;

ALTER TABLE    product_review         DROP CONSTRAINT IF EXISTS fk____product_review____products ;
ALTER TABLE    product_review          ADD CONSTRAINT           fk____product_review____products          FOREIGN KEY ( product_id )      REFERENCES  products ( product_id )             ;

ALTER TABLE    product_stats          DROP CONSTRAINT IF EXISTS fk____product_stats____products ;
ALTER TABLE    product_stats           ADD CONSTRAINT           fk____product_stats____products           FOREIGN KEY ( product_id )      REFERENCES  products ( product_id )             ;

ALTER TABLE    products               DROP CONSTRAINT IF EXISTS fk____products____manufacturer ;
ALTER TABLE    products                ADD CONSTRAINT           fk____products____manufacturer            FOREIGN KEY ( manuf_id )        REFERENCES  manufacturer ( manuf_id )           ;

ALTER TABLE    products               DROP CONSTRAINT IF EXISTS fk____products____product_category ;
ALTER TABLE    products                ADD CONSTRAINT           fk____products____product_category        FOREIGN KEY ( category_id )     REFERENCES  product_category ( category_id )    ;

ALTER TABLE    sessions               DROP CONSTRAINT IF EXISTS fk____sessions____users ;
ALTER TABLE    sessions                ADD CONSTRAINT           fk____sessions____users                   FOREIGN KEY ( member_id )       REFERENCES  users ( member_id )                 ;

ALTER TABLE    shipment               DROP CONSTRAINT IF EXISTS fk____shipment____orders ;
ALTER TABLE    shipment                ADD CONSTRAINT           fk____shipment____orders                  FOREIGN KEY ( order_id )        REFERENCES  orders ( order_id )                 ;

ALTER TABLE    shipment               DROP CONSTRAINT IF EXISTS fk____shipment____customer_address ;
ALTER TABLE    shipment                ADD CONSTRAINT           fk____shipment____customer_address        FOREIGN KEY ( address_id )      REFERENCES  customer_address ( address_id )     ;

ALTER TABLE    shopping_cart          DROP CONSTRAINT IF EXISTS fk____shopping_cart____users ;
ALTER TABLE    shopping_cart           ADD CONSTRAINT           fk____shopping_cart____users              FOREIGN KEY ( member_id )       REFERENCES  users ( member_id )                 ;

ALTER TABLE    shopping_cart          DROP CONSTRAINT IF EXISTS fk____shopping_cart____products ;
ALTER TABLE    shopping_cart           ADD CONSTRAINT           fk____shopping_cart____products           FOREIGN KEY ( product_id )      REFERENCES  products ( product_id )             ;

ALTER TABLE    shopping_cart          DROP CONSTRAINT IF EXISTS fk____shopping_cart____sessions ;
ALTER TABLE    shopping_cart           ADD CONSTRAINT           fk____shopping_cart____sessions           FOREIGN KEY ( session_id )      REFERENCES  sessions ( session_id )             ;

ALTER TABLE    vouchers               DROP CONSTRAINT IF EXISTS fk____vouchers____promotion ;
ALTER TABLE    vouchers                ADD CONSTRAINT           fk____vouchers____promotion               FOREIGN KEY ( promotion_id )    REFERENCES  promotion ( promotion_id )          ;

ALTER TABLE    vouchers_applied       DROP CONSTRAINT IF EXISTS fk____vouchers_applied____orders ;
ALTER TABLE    vouchers_applied        ADD CONSTRAINT           fk____vouchers_applied____orders          FOREIGN KEY ( order_id )        REFERENCES  orders ( order_id )                 ;

ALTER TABLE    vouchers_applied       DROP CONSTRAINT IF EXISTS fk____vouchers_applied____vouchers ;
ALTER TABLE    vouchers_applied        ADD CONSTRAINT           fk____vouchers_applied____vouchers          FOREIGN KEY ( voucher_id )    REFERENCES  vouchers ( voucher_id )             ;
