/*
เนื่องจากข้อมูลในไฟล์ .csv ที่ Import เข้า SQLite ไม่ได้มีการกำหนด Data Type มา
จึงต้องทำการสร้างตารางใหม่ เพื่อกำหนด Primary Key และ Data Type ของแต่ละคอลัมให้ถูกต้อง
*/

CREATE TABLE accounts_new (
account TEXT PRIMARY KEY,
sector TEXT,
year_established INTEGER,
revenue NUMERIC,
employees INTEGER,
office_location TEXT,
subsidiary_of TEXT
);

CREATE TABLE products_new (
product TEXT PRIMARY KEY,
series TEXT,
sales_price NUMERIC
);

CREATE TABLE sales_teams_new (
sales_agent TEXT PRIMARY KEY,
manager TEXT,
regional_office TEXT
);

CREATE TABLE sales_pipeline_new (
opportunity_id TEXT PRIMARY KEY,
sales_agent TEXT,
product TEXT,
account TEXT,
deal_stage TEXT,
engage_date DATETIME,
close_date DATETIME,
close_value NUMERIC,

/*
ตาราง sales_pipeline เป็นตารางหลัก ใช้ REFERENCES เพื่อเชื่อม Foreign Key เข้ากับตาราง
*/

FOREIGN KEY (sales_agent) REFERENCES sales_teams(sales_agent),
FOREIGN KEY (product) REFERENCES products(product),
FOREIGN KEY (account) REFERENCES accounts(account)
);

/*
นำข้อมูลจากตารางเก่ามาใส่ในตารางใหม่ ด้วย INSERT INTO
*/

INSERT INTO accounts_new
SELECT * FROM accounts;

INSERT INTO products_new
SELECT * FROM products;

INSERT INTO sales_teams_new
SELECT * FROM sales_teams;

INSERT INTO sales_pipeline_new
SELECT * FROM sales_pipeline;

/*
DROP ตารางเก่าทิ้ง แล้วใช้ ALTER เปลี่ยนชื่อตารางใหม่ เพื่อให้ได้ข้อมูลที่สมบูรณ์ มี Data Type และ Primary Key ครบถ้วน
*/

DROP TABLE accounts;
DROP TABLE products;
DROP TABLE sales_teams;
DROP TABLE sales_pipeline;

ALTER TABLE accounts_new RENAME TO accounts;
ALTER TABLE products_new RENAME TO products;
ALTER TABLE sales_teams_new RENAME TO sales_teams;
ALTER TABLE sales_pipeline_new RENAME TO sales_pipeline;
