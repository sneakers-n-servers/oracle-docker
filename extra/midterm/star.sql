DROP TABLE fact_sale;
DROP TABLE dim_customer;
DROP TABLE dim_weather;
DROP TABLE dim_store;
DROP TABLE dim_book;

CREATE TABLE dim_book(
  name VARCHAR(255) PRIMARY KEY, 
  num_pages INTEGER,
  publisher VARCHAR(255) NOT NULL,
  CONSTRAINT positive_pages CHECK(num_pages > 0)
);

CREATE TABLE dim_store(
  location VARCHAR(255) PRIMARY KEY,
  address VARCHAR(1000)
);

CREATE TABLE dim_weather(
  location VARCHAR(255) PRIMARY KEY,
  wdate DATE,
  temperature INTEGER,
  weather VARCHAR(255),
  CONSTRAINT valid_weather CHECK(weather IN ('rainy', 'sunny', 'cloudy', 'snow')),
  CONSTRAINT fk_location FOREIGN KEY(location) REFERENCES dim_store(location)
);

CREATE TABLE dim_customer(
  name VARCHAR(255),
  email VARCHAR(255) PRIMARY KEY
);

CREATE TABLE fact_sale(
  book_name VARCHAR(255),
  store_location VARCHAR(255),
  customer_email VARCHAR(255),
  purchase_price INTEGER,
  sale_date TIMESTAMP,
  quantity INTEGER,
  CONSTRAINT fk_book FOREIGN KEY(book_name) REFERENCES dim_book(name),
  CONSTRAINT fk_store FOREIGN KEY(store_location) REFERENCES dim_store(location),
  CONSTRAINT fk_customer FOREIGN KEY(customer_email) REFERENCES dim_customer(email),
  PRIMARY KEY(book_name, store_location, customer_email, purchase_price, sale_date, quantity), 
  CONSTRAINT positive_quantity CHECK(quantity > 0)
);


SELECT publisher COUNT(quantity) AS total
FROM fact_sale NATURAL JOIN dim_book
GROUP BY publisher
ORDER BY total DESC;

SELECT sale_date, weather
FROM fact_sale NATURAL join dim_whether
WHERE sale_date BETWEEN TO_DATE('28/02/2020', 'DD/MM/YYYY') AND TO_DATE('20/06/2020', 'DD/MM/YYYY');

SELECT bookname, num_pages,
FROM fact_sale NATURAL JOIN dim_book
ORDER BY book_name;


