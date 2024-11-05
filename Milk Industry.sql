-- Create the database and set it for use
CREATE DATABASE milk_industry; 
USE milk_industry;

-- ---------------------------------------------------------------------------
-- Create Tables
-- ---------------------------------------------------------------------------

-- Creating a table for countries, with 'code' as the primary key
CREATE TABLE countries (
    code CHAR(3) NOT NULL,              -- Country code (e.g., GER for Germany)
    name VARCHAR(255) NOT NULL,         -- Country name
    
    PRIMARY KEY (code),                 -- Set 'code' as primary key
    CONSTRAINT uq_country_code UNIQUE (code) -- Ensure 'code' is unique
);

-- Creating a table for factories linked to countries
CREATE TABLE factories (
    id INTEGER NOT NULL AUTO_INCREMENT, -- Unique identifier for each factory
    name VARCHAR(255) NOT NULL,         -- Factory name
    country_code CHAR(3) NOT NULL,     -- Code of the country the factory is in
    
    PRIMARY KEY (id),                   -- Set 'id' as primary key
    FOREIGN KEY (country_code) REFERENCES countries(code), -- Foreign key reference to countries
    CONSTRAINT uq_factory_name UNIQUE (name) -- Ensure factory name is unique
);

-- Creating a table for stores linked to countries
CREATE TABLE stores (
    id INTEGER NOT NULL AUTO_INCREMENT, -- Unique identifier for each store
    name VARCHAR(255) NOT NULL,         -- Store name
    country_code CHAR(3) NOT NULL,     -- Code of the country the store is in
    
    PRIMARY KEY (id),                   -- Set 'id' as primary key
    FOREIGN KEY (country_code) REFERENCES countries(code), -- Foreign key reference to countries
    CONSTRAINT uq_store_name UNIQUE (name) -- Ensure store name is unique
);

-- Creating a table for product categories
CREATE TABLE product_categories (
    id INTEGER NOT NULL AUTO_INCREMENT, -- Unique identifier for each category
    category_name VARCHAR(255) NOT NULL, -- Name of the product category
    
    PRIMARY KEY (id),                   -- Set 'id' as primary key
    CONSTRAINT uq_category_name UNIQUE (category_name) -- Ensure category name is unique
);

-- Creating a table for products linked to categories, factories, and stores
CREATE TABLE products (
    material_id INTEGER NOT NULL AUTO_INCREMENT, -- Unique identifier for each product
    ean_code VARCHAR(13) NOT NULL,              -- EAN code for the product
    product_name VARCHAR(255) NOT NULL,         -- Name of the product
    category_id INTEGER NOT NULL,                -- Reference to the product category
    factory_id INTEGER NOT NULL,                 -- Reference to the factory producing the product
    store_id INTEGER NOT NULL,                   -- Reference to the store selling the product
    fat_percentage DECIMAL(5, 2) NOT NULL,      -- Fat percentage in the product
    net_weight DECIMAL(10, 2) NOT NULL,         -- Net weight of the product
    gross_weight DECIMAL(10, 2) NOT NULL,       -- Gross weight of the product
    is_plant_based BOOLEAN NOT NULL DEFAULT 0,   -- Indicator if the product is plant-based
    production_type VARCHAR(255) NOT NULL,      -- Type of production (e.g., UHT, Pasteurized)
    
    PRIMARY KEY (material_id),                 -- Set 'material_id' as primary key
    FOREIGN KEY (category_id) REFERENCES product_categories(id), -- Foreign key reference to categories
    FOREIGN KEY (factory_id) REFERENCES factories(id), -- Foreign key reference to factories
    FOREIGN KEY (store_id) REFERENCES stores(id), -- Foreign key reference to stores
    
    -- Constraints for product attributes
    CONSTRAINT uq_ean_code UNIQUE (ean_code), -- Ensure EAN code is unique
    CONSTRAINT chk_fat_percentage CHECK (fat_percentage >= 0 AND fat_percentage <= 100), -- Fat percentage must be between 0 and 100
    CONSTRAINT chk_net_gross_weight CHECK (net_weight <= gross_weight), -- Net weight cannot exceed gross weight
    CONSTRAINT chk_positive_net_weight CHECK (net_weight > 0), -- Net weight must be positive
    CONSTRAINT chk_positive_gross_weight CHECK (gross_weight > 0), -- Gross weight must be positive
    CONSTRAINT chk_ean_no_leading_zero CHECK (LEFT(ean_code, 1) <> '0') -- EANs cannot start with 0
);

-- ---------------------------------------------------------------------------
-- Insert Initial Data
-- ---------------------------------------------------------------------------

-- Insert data into the countries table
INSERT INTO countries (code, name)
VALUES 
    ('GER', 'Germany'),
    ('FRA', 'France'),
    ('NLD', 'Netherlands'),
    ('ITA', 'Italy'),
    ('ESP', 'Spain');

SELECT * FROM countries; -- Display the countries data

-- Insert data into the factories table
INSERT INTO factories (name, country_code)
VALUES 
    ('DairyTech Factory', 'GER'),
    ('GreenPastures Factory', 'NLD'),
    ('BioMilk Production', 'FRA'),
    ('AlpenMilch Factory', 'GER'),
    ('FreshCheese Factory', 'FRA'),
    ('PureDairy Products', 'ITA'),
    ('Mediterranean Dairy', 'ESP');

SELECT * FROM factories; -- Display the factories data

-- Insert data into the stores table
INSERT INTO stores (name, country_code)
VALUES 
    ('SuperMart', 'GER'),
    ('MegaGroceries', 'FRA'),
    ('LeSuper Marché', 'FRA'),
    ('GlobalMart', 'NLD'),
    ('DairyDepot', 'NLD'),
    ('GroceryPalace', 'ITA'),
    ('MarketFresh', 'ESP'),
    ('EuroDairy Shop', 'ESP');

SELECT * FROM stores; -- Display the stores data

-- Insert data into the product categories table
INSERT INTO product_categories (category_name)
VALUES 
    ('Milk UHT'),
    ('Milk Non-UHT'),
    ('Butter'),
    ('Yogurt'),
    ('Flavored Milk'),
    ('Cheese'),
    ('Sour Cream');

SELECT * FROM product_categories; -- Display the product categories data

-- Insert data into the products table
INSERT INTO products (ean_code, product_name, category_id, factory_id, store_id, fat_percentage, net_weight, gross_weight, is_plant_based, production_type)
VALUES 
    ('1234567890123', 'UHT Milk 1L', 1, 1, 1, 3.5, 1000, 1050, 0, 'UHT'),
    ('2345678901234', 'Non-UHT Milk 500ml', 2, 2, 2, 3.2, 500, 530, 0, 'Pasteurized'),
    ('3456789012345', 'Butter 80% Fat', 3, 3, 3, 80.0, 250, 260, 0, 'Pasteurized'),
    ('4567890123456', 'Strawberry Flavored Milk', 5, 4, 4, 1.5, 330, 350, 0, 'UHT'),
    ('5678901234567', 'Plant-based Almond Milk', 1, 5, 5, 1.0, 1000, 1050, 1, 'Pasteurized'),
    ('6789012345678', 'Italian Parmesan Cheese', 6, 6, 6, 32.0, 200, 210, 0, 'Aged'),
    ('7890123456789', 'Spanish Sour Cream', 7, 7, 7, 20.0, 300, 320, 0, 'Fermented'),
    ('8901234567890', 'Greek Yogurt 500g', 4, 3, 4, 10.0, 500, 520, 0, 'Fermented'),
    ('9012345678901', 'Low-Fat Milk 1L', 1, 2, 2, 1.5, 1000, 1030, 0, 'Pasteurized'),
    ('1234567890124', 'Blueberry Flavored Yogurt 200g', 4, 4, 4, 5.0, 200, 210, 0, 'Fermented'),
    ('2345678901235', 'Cream Cheese 250g', 3, 1, 1, 33.0, 250, 260, 0, 'Pasteurized');

SELECT * FROM products; -- Display the products data

-- ---------------------------------------------------------------------------
-- Create Views
-- ---------------------------------------------------------------------------

-- Create a view summarizing products by category and fat percentage
CREATE VIEW category_product_summary AS
SELECT 
    pc.category_name,          -- Category name from product_categories
    p.product_name,            -- Product name from products table
    p.fat_percentage           -- Fat percentage for each product
FROM 
    product_categories pc      -- The product_categories table
LEFT JOIN 
    products p                 -- The products table
ON 
    pc.id = p.category_id;     -- Join condition: category_id in products matches id in product_categories

-- Display the product summary view
SELECT * FROM category_product_summary;

-- ---------------------------------------------------------------------------
-- Define a function to calculate the average fat percentage for a specific category
DELIMITER //
CREATE FUNCTION avg_fat_percentage(input_category_id INT) 
RETURNS FLOAT
DETERMINISTIC
BEGIN
    -- Return the average fat percentage for the given category ID
    RETURN (
        SELECT AVG(fat_percentage)        -- Calculate the average fat percentage
        FROM products                     -- From the products table
        WHERE category_id = input_category_id   -- Filter by the input category ID
    );
END //
DELIMITER ;
-- ---------------------------------------------------------------------------
-- Display the average fat percentage for category 1 (Milk UHT) 
SELECT avg_fat_percentage(1) AS average_fat_for_category_1;

-- ---------------------------------------------------------------------------
-- Create a view of products with fat percentage above the category average
CREATE VIEW products_above_average_fat AS
SELECT p.product_name, p.fat_percentage, p.category_id
FROM products p
WHERE p.fat_percentage > (
    SELECT AVG(fat_percentage)
    FROM products
    WHERE category_id = p.category_id
);

-- Display the products with fat percentage above the category average
SELECT * FROM products_above_average_fat;

-- ---------------------------------------------------------------------------
-- Create a view for product sales, showing factory and store information
CREATE VIEW product_sales AS
SELECT p.product_name, f.name AS factory_name, s.name AS store_name
FROM products p
JOIN factories f ON p.factory_id = f.id
JOIN stores s ON p.store_id = s.id;

-- Display the product sales data
SELECT * FROM product_sales;

-- ---------------------------------------------------------------------------
-- Count the number of products by store and display the top 3 stores with the most products
SELECT store_name, COUNT(*) AS product_count
FROM product_sales
GROUP BY store_name
ORDER BY product_count DESC
LIMIT 3;

-- ---------------------------------------------------------------------------
-- Display all products from factories containing the term 'Milk'
SELECT f.name AS factory_name, p.product_name
FROM factories f
JOIN products p ON f.id = p.factory_id
WHERE p.product_name LIKE '%Milk%';

-- ---------------------------------------------------------------------------
-- Display product name in uppercase, factory name in lowercase, and a short product name
SELECT UPPER(p.product_name) AS product_uppercase, 
       LOWER(f.name) AS factory_lowercase, 
       SUBSTRING(p.product_name, 1, 5) AS product_shortname
FROM products p
JOIN factories f ON p.factory_id = f.id;

-- ---------------------------------------------------------------------------
-- Display rounded, ceiling, and floored values for product attributes
SELECT p.product_name, 
       ROUND(p.net_weight, 2) AS rounded_net_weight,
       CEIL(p.gross_weight) AS ceiling_gross_weight,
       FLOOR(p.fat_percentage) AS floored_fat_percentage
FROM products p;

-- ---------------------------------------------------------------------------
-- Create the product_pricing table for storing product pricing details
CREATE TABLE product_pricing (
    product_id INTEGER NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(5, 2),
    shipping_cost DECIMAL(10, 2),
    PRIMARY KEY (product_id),
    FOREIGN KEY (product_id) REFERENCES products(material_id)
);

-- Create the exchange_rates table for storing currency exchange rates to EUR
CREATE TABLE exchange_rates (
    currency_code CHAR(3) NOT NULL,
    rate_to_euro DECIMAL(10, 4) NOT NULL,
    PRIMARY KEY (currency_code)
);

-- ---------------------------------------------------------------------------
-- Insert sample data into product_pricing
INSERT INTO product_pricing (product_id, base_price, discount, shipping_cost)
VALUES 
(1, 10.99, 1.50, 2.00),
(2, 5.49, 0.50, 1.50),
(3, 3.99, NULL, 1.00),
(4, 2.49, 0.25, 0.75),
(5, 3.99, 0.50, 1.00),
(6, 15.99, 2.00, 3.00),
(7, 6.49, 0.75, 1.50);

-- Insert sample data into exchange_rates (Currency: USD to EUR)
INSERT INTO exchange_rates (currency_code, rate_to_euro)
VALUES 
('USD', 1.1);

-- ---------------------------------------------------------------------------
-- Create a view to show product prices in EUR, including discount and shipping
CREATE VIEW product_prices_in_eur AS
SELECT 
    p.product_name,
    pp.base_price,
    IF(pp.discount IS NULL, 0, pp.discount) AS discount,
    pp.shipping_cost,
    (pp.base_price - IF(pp.discount IS NULL, 0, pp.discount) + pp.shipping_cost) AS full_price_eur
FROM products p
JOIN product_pricing pp ON p.material_id = pp.product_id;

-- Display the product prices in EUR
SELECT * FROM product_prices_in_eur;

-- ---------------------------------------------------------------------------
-- Create a function to convert EUR to USD based on the exchange rate
DELIMITER //
CREATE FUNCTION convert_eur_to_usd(eur_amount DECIMAL(10, 2)) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    RETURN eur_amount * (SELECT rate_to_euro FROM exchange_rates WHERE currency_code = 'USD');
END //
DELIMITER ;

-- ---------------------------------------------------------------------------
-- Create a view to show product prices in USD
CREATE VIEW product_prices_in_usd AS
SELECT 
    p.product_name,
    convert_eur_to_usd(pp.base_price) AS base_price_usd,
    convert_eur_to_usd(IF(pp.discount IS NULL, 0, pp.discount)) AS discount_usd,
    convert_eur_to_usd(pp.shipping_cost) AS shipping_cost_usd,
    convert_eur_to_usd(pp.base_price - IF(pp.discount IS NULL, 0, pp.discount) + pp.shipping_cost) AS full_price_usd
FROM products p
JOIN product_pricing pp ON p.material_id = pp.product_id;

-- Display the product prices in USD
SELECT * FROM product_prices_in_usd;

-- ---------------------------------------------------------------------------
-- Creating a procedure to update the discount as a fixed euro amount in product_pricing based on the product name
DELIMITER //
CREATE PROCEDURE apply_fixed_discount_to_product(
    input_product_name VARCHAR(255), 
    discount_amount DECIMAL(10, 2)
)
BEGIN
    UPDATE product_pricing pp
    JOIN products p ON pp.product_id = p.material_id
    SET pp.discount = discount_amount
    WHERE p.product_name = input_product_name;
END //
DELIMITER ;

-- Apply a fixed €0.50 discount to 'UHT Milk 1L'
CALL apply_fixed_discount_to_product('UHT Milk 1L', 0.50);

-- ---------------------------------------------------------------------------
-- Creating a procedure to update the net weight of a product and a trigger to update the gross weight accordingly:
DELIMITER //
CREATE PROCEDURE update_net_weight(
    IN product_material_id INTEGER,
    IN new_net_weight DECIMAL(10, 2)
)
BEGIN
    UPDATE products
    SET net_weight = new_net_weight
    WHERE material_id = product_material_id;
END //
DELIMITER ;

-- Update the net weight of the product with material_id 1
CALL update_net_weight(1, 50.00); 

-- ---------------------------------------------------------------------------
-- Trigger to automatically update the gross weight if the net weight is changed
DELIMITER //
CREATE TRIGGER update_gross_weight
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    IF NEW.net_weight <> OLD.net_weight THEN
        SET NEW.gross_weight = OLD.gross_weight + (NEW.net_weight - OLD.net_weight);
    END IF;
END //
DELIMITER ;

-- ---------------------------------------------------------------------------
-- Trigger to raise an error if the net weight is changed by more than 5%
DELIMITER //
CREATE TRIGGER validate_net_weight_change
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    DECLARE weight_change_percentage DECIMAL(5, 2);
    SET weight_change_percentage = ABS(NEW.net_weight - OLD.net_weight) / OLD.net_weight * 100;
    IF weight_change_percentage > 5 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Net weight cannot be changed by more than 5%.';
    END IF;
END //
DELIMITER ;

-- ---------------------------------------------------------------------------
-- Creating an event to log daily product counts into product_count_log table
CREATE TABLE product_count_log (
    log_date DATETIME NOT NULL,
    product_count INT NOT NULL,
    
    PRIMARY KEY (log_date)
);

-- Create an event to log product count daily
DELIMITER //
CREATE EVENT log_product_count
ON SCHEDULE EVERY 1 DAY
STARTS '2024-10-07 00:00:00'  -- Change to your desired start date
DO
BEGIN
    INSERT INTO product_count_log (log_date, product_count)
    VALUES (NOW(), (SELECT COUNT(*) FROM products));
END //
DELIMITER ;
