-- Creating table for countries
CREATE TABLE Countries (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(50) NOT NULL UNIQUE
);

-- Creating table for DTAA treaties
CREATE TABLE DTAA_Treaties (
    treaty_id INT PRIMARY KEY,
    country_id INT,
    partner_country_id INT,
    treaty_type VARCHAR(20), -- Exemption, Reduced Rate, Credit Method
    normal_tax_rate DECIMAL(5, 2), -- Normal tax rate in percentage
    dtaa_tax_rate DECIMAL(5, 2),   -- DTAA tax rate in percentage
    year_of_agreement int,
    FOREIGN KEY (country_id) REFERENCES Countries(country_id),
    FOREIGN KEY (partner_country_id) REFERENCES Countries(country_id)
);

-- Creating table for tax payments
CREATE TABLE Tax_Payments (
    payment_id INT PRIMARY KEY,
    country_id INT,
    income_amount DECIMAL(15, 2),
    tax_paid DECIMAL(15, 2),
    payment_year int,
    FOREIGN KEY (country_id) REFERENCES Countries(country_id)
);


-- inserting DATA statements
INSERT INTO Countries (country_id, country_name) VALUES
(1, 'United States'),
(2, 'India'),
(3, 'United Kingdom'),
(4, 'Germany'),
(5, 'Canada'),
(6, 'Australia'),
(7, 'France'),
(8, 'Singapore'),
(9, 'Brazil'),
(10, 'South Africa');


INSERT INTO DTAA_Treaties (treaty_id, country_id, partner_country_id, treaty_type, normal_tax_rate, dtaa_tax_rate, year_of_agreement) VALUES
(1, 1, 10, 'Exemption', 34.57, 11.65, 2008),
(2, 2, 8, 'Exemption', 22.05, 19.29, 2010),
(3, 3, 5, 'Credit Method', 34.28, 7.28, 2023),
(4, 4, 3, 'Reduced Rate', 26.12, 12.24, 2009),
(5, 5, 2, 'Exemption', 28.60, 16.47, 2000),
(6, 6, 9, 'Reduced Rate', 30.45, 14.35, 2015),
(7, 7, 4, 'Credit Method', 32.00, 8.45, 2012),
(8, 8, 7, 'Exemption', 25.50, 9.75, 2021),
(9, 9, 6, 'Reduced Rate', 29.85, 10.50, 2017),
(10, 10, 1, 'Credit Method', 27.60, 6.90, 2005)
;


-- Step 2: Insert tax payment data for 20 countries over the past 5 years
INSERT INTO Tax_Payments (payment_id, country_id, income_amount, tax_paid, payment_year)
VALUES 
    -- Country 1: USA
    (101, 1, 100000, 15000, 2020),
    (102, 1, 110000, 16500, 2021),
    (103, 1, 120000, 18000, 2022),
    (104, 1, 125000, 19000, 2023),
    (105, 1, 130000, 20000, 2024),

    -- Country 2: UK
    (106, 3, 90000, 14000, 2020),
    (107, 3, 95000, 14500, 2021),
    (108, 3, 98000, 14700, 2022),
    (109, 3, 100000, 15000, 2023),
    (110, 3, 105000, 15500, 2024),

    -- Country 3: India
    (111, 2, 80000, 12000, 2020),
    (112, 2, 85000, 12750, 2021),
    (113, 2, 87000, 13050, 2022),
    (114, 2, 89000, 13350, 2023),
    (115, 2, 92000, 13800, 2024),

    -- Country 4: Canada
    (116, 5, 110000, 16500, 2020),
    (117, 5, 115000, 17250, 2021),
    (118, 5, 120000, 18000, 2022),
    (119, 5, 122000, 18300, 2023),
    (120, 5, 125000, 18750, 2024),

    -- Country 5: Germany
    (121, 4, 105000, 16000, 2020),
    (122, 4, 108000, 16500, 2021),
    (123, 4, 112000, 16800, 2022),
    (124, 4, 115000, 17250, 2023),
    (125, 4, 120000, 18000, 2024),

    -- Country 6: France
    (126, 7, 95000, 14500, 2020),
    (127, 7, 98000, 14700, 2021),
    (128, 7, 100000, 15000, 2022),
    (129, 7, 102000, 15300, 2023),
    (130, 7, 105000, 15750, 2024),


    -- Country 7: Australia
    (136, 6, 90000, 13500, 2020),
    (137, 6, 92000, 13800, 2021),
    (138, 6, 95000, 14250, 2022),
    (139, 6, 98000, 14700, 2023),
    (140, 6, 100000, 15000, 2024),

    -- Country 8: Brazil
    (141, 9, 85000, 12750, 2020),
    (142, 9, 87000, 13050, 2021),
    (143, 9, 89000, 13350, 2022),
    (144, 9, 91000, 13650, 2023),
    (145, 9, 94000, 14100, 2024),

    
    -- Country 9: South Africa
    (176, 10, 85000, 13000, 2020),
    (177, 10, 88000, 13200, 2021),
    (178, 10, 91000, 13650, 2022),
    (179, 10, 94000, 14100, 2023),
    (180, 10, 97000, 14550, 2024),


    -- Country 10: Singapore
    (186, 8, 95000, 14500, 2020),
    (187, 8, 98000, 14700, 2021),
    (188, 8, 100000, 15000, 2022),
    (189, 8, 103000, 15450, 2023),
    (190, 8, 106000, 15900, 2024),

--NOw we're done with data inserting and now we can move to executing some queries for data extraction
--runnig queriess
--1st
SELECT
    c.country_name,
    p.income_amount,
	payment_year,
    t.normal_tax_rate,
    t.dtaa_tax_rate,
    round(p.income_amount * (t.normal_tax_rate / 100),2) AS tax_without_dtaa,
    round(p.income_amount * (t.dtaa_tax_rate / 100),2) AS tax_with_dtaa
FROM 
    Tax_Payments p
JOIN 
    DTAA_Treaties t ON p.country_id = t.country_id
JOIN 
    Countries c ON p.country_id = c.country_id;

--2nd
SELECT 
    c.country_name,
    t.partner_country_id,
    MIN(t.dtaa_tax_rate) AS min_dtaa_rate
FROM 
    DTAA_Treaties t
JOIN 
    Countries c ON t.country_id = c.country_id
GROUP BY 
    c.country_name, t.partner_country_id
ORDER BY 
    min_dtaa_rate ASC;


-- 3rd
SELECT 
    c.country_name,
	p.payment_year,
    ROUND(SUM(p.income_amount * (t.normal_tax_rate - t.dtaa_tax_rate) / 100), 2) AS revenue_loss
FROM 
    Tax_Payments p
JOIN 
    DTAA_Treaties t ON p.country_id = t.country_id
JOIN 
    Countries c ON p.country_id = c.country_id
WHERE 
    p.payment_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 5  -- Include only payments from the past 5 years
GROUP BY 
    c.country_name,
	p.payment_year
ORDER BY 
    revenue_loss DESC;


