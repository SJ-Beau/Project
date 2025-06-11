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

FOREIGN KEY (sales_agent) REFERENCES sales_teams(sales_agent),
FOREIGN KEY (product) REFERENCES products(product),
FOREIGN KEY (account) REFERENCES accounts(account)

);

INSERT INTO accounts_new
SELECT * FROM accounts;

INSERT INTO products_new
SELECT * FROM products;

INSERT INTO sales_teams_new
SELECT * FROM sales_teams;

INSERT INTO sales_pipeline_new
SELECT * FROM sales_pipeline;
