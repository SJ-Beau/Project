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

CREATE TABLE target_kpi_new (
target_year_month DATE PRIMARY KEY,
monthly_target_central NUMERIC,
monthly_target_east NUMERIC,
monthly_target_west NUMERIC,
monthly_target_total NUMERIC
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

INSERT INTO target_kpi_new
SELECT * FROM target_kpi;

INSERT INTO sales_pipeline_new
SELECT * FROM sales_pipeline;

/*
DROP ตารางเก่าทิ้ง แล้วใช้ ALTER เปลี่ยนชื่อตารางใหม่ เพื่อให้ได้ข้อมูลที่สมบูรณ์ มี Data Type และ Primary Key ครบถ้วน
*/

DROP TABLE accounts;
DROP TABLE products;
DROP TABLE sales_teams;
DROP TABLE target_kpi;
DROP TABLE sales_pipeline;

ALTER TABLE accounts_new RENAME TO accounts;
ALTER TABLE products_new RENAME TO products;
ALTER TABLE sales_teams_new RENAME TO sales_teams;
ALTER TABLE target_kpi_new RENAME TO target_kpi;
ALTER TABLE sales_pipeline_new RENAME TO sales_pipeline;

/*
เนื่องจากพบว่าใน sales_pipline.product มีข้อมูลที่ผิดอยู่ จาก GTX Pro กลายเป็น GTXPro (ไม่มีเว้นวรรค)
ซึ่งจะทำให้การเชื่อม Foriegn Key ได้ไม่ตรง จึงต้องแก้ให้เป็น GTX Pro โดยการใช้ UPDATE
*/

UPDATE sales_pipeline
SET product = 'GTX Pro'
WHERE product = 'GTXPro';

/*
ลองเอาตารางทั้งหมดมารวมเข้าด้วยกัน แล้วจัดเรียงคอลัมใหม่
ใช้ STRFTIME เพิ่มคอลัม close_month_year, close_year} close_month โดยอ้างอิงจาก close_date
เพื่อไว้ใช้ JOIN กับตาราง target_kpi
*/

SELECT
sales_pipeline.opportunity_id,
sales_pipeline.deal_stage,
sales_pipeline.engage_date,
sales_pipeline.close_date,
STRFTIME('%Y-%m', close_date) AS close_month_year,
STRFTIME('%Y', close_date) AS close_year,
STRFTIME('%m', close_date) AS close_month,
sales_pipeline.close_value,
sales_pipeline.sales_agent,
sales_teams.manager,
sales_teams.regional_office,
products.product,
products.series AS product_series,
products.sales_price,
accounts.account AS comp_name,
accounts.subsidiary_of AS sub_of_comp,
accounts.sector AS industry,
accounts.year_established,
accounts.revenue AS comp_annual_rev,
accounts.employees AS no_of_emp,
accounts.office_location AS comp_location
FROM
sales_pipeline
JOIN
products ON sales_pipeline.product = products.product
JOIN
sales_teams ON sales_pipeline.sales_agent = sales_teams.sales_agent
JOIN
accounts ON sales_pipeline.account = accounts.account;
