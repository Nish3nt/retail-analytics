-- ============================================================
-- SEED DATA — Retail Analytics
-- ============================================================
USE retail_analytics;

-- Regions
INSERT INTO dim_regions (region_name, country, timezone) VALUES
('North','India','Asia/Kolkata'),
('South','India','Asia/Kolkata'),
('East','India','Asia/Kolkata'),
('West','India','Asia/Kolkata'),
('Central','India','Asia/Kolkata');

-- Categories
INSERT INTO dim_categories (category_name, parent_id) VALUES
('Electronics', NULL),
('Fashion', NULL),
('Home & Kitchen', NULL),
('Sports & Fitness', NULL),
('Books & Stationery', NULL),
('Mobiles', 1),
('Laptops', 1),
('Accessories', 1),
('Men\'s Wear', 2),
('Women\'s Wear', 2),
('Kitchen Appliances', 3),
('Furniture', 3),
('Exercise Equipment', 4),
('Outdoor Sports', 4);

-- Products (20 products)
INSERT INTO dim_products (product_name, sku, category_id, brand, unit_cost, unit_price, stock_qty, launch_date) VALUES
('Samsung Galaxy A54',       'MOB-001', 6,  'Samsung',  18000, 28999, 150, '2023-04-15'),
('Apple iPhone 15',          'MOB-002', 6,  'Apple',    55000, 79999, 80,  '2023-09-22'),
('OnePlus Nord CE 3',        'MOB-003', 6,  'OnePlus',  15000, 22999, 200, '2023-07-10'),
('Dell Inspiron 15',         'LAP-001', 7,  'Dell',     35000, 52999, 60,  '2023-01-20'),
('HP Pavilion x360',         'LAP-002', 7,  'HP',       40000, 62999, 45,  '2023-03-12'),
('Lenovo IdeaPad Slim 5',    'LAP-003', 7,  'Lenovo',   32000, 47999, 75,  '2022-11-05'),
('boAt Rockerz 450',         'ACC-001', 8,  'boAt',     800,   1799,  500, '2022-06-01'),
('Logitech MX Master 3',     'ACC-002', 8,  'Logitech', 4500,  8499,  120, '2023-02-14'),
('Allen Solly Men Shirt',    'MEN-001', 9,  'Allen Solly', 600, 1499,  300, '2023-01-01'),
('Levi\'s 511 Slim Jeans',   'MEN-002', 9,  'Levi\'s',  1200,  2999,  250, '2023-01-01'),
('W Women Kurta Set',        'WOM-001', 10, 'W',        700,   1799,  400, '2023-03-08'),
('Biba Ethnic Dress',        'WOM-002', 10, 'Biba',     900,   2299,  180, '2023-03-08'),
('Philips Air Fryer',        'KIT-001', 11, 'Philips',  4000,  7499,  90,  '2022-12-20'),
('Instant Pot Duo',          'KIT-002', 11, 'Instant Pot', 5500, 9999, 60, '2023-04-01'),
('IKEA Kallax Shelf',        'FUR-001', 12, 'IKEA',     6000,  10999, 40,  '2023-05-15'),
('Cosco Fitness Cycle',      'EXC-001', 13, 'Cosco',    8000,  14999, 55,  '2023-06-01'),
('Adidas Running Shoes',     'SPT-001', 14, 'Adidas',   2500,  5999,  200, '2023-02-01'),
('Yonex Badminton Racket',   'SPT-002', 14, 'Yonex',    800,   1999,  300, '2023-01-15'),
('Atomic Habits (Book)',     'BOK-001', 5,  'Penguin',  150,   499,   600, '2019-10-01'),
('Python Crash Course',      'BOK-002', 5,  'No Starch',350,   799,   250, '2023-05-01');

-- Sales Reps
INSERT INTO dim_salesreps (full_name, email, region_id, hire_date) VALUES
('Arjun Sharma',   'arjun.s@retailiq.in',   1, '2020-01-15'),
('Priya Nair',     'priya.n@retailiq.in',   2, '2020-03-22'),
('Rohit Desai',    'rohit.d@retailiq.in',   3, '2021-06-10'),
('Sneha Kulkarni', 'sneha.k@retailiq.in',   4, '2021-09-01'),
('Vikram Joshi',   'vikram.j@retailiq.in',  5, '2022-02-14'),
('Anita Menon',    'anita.m@retailiq.in',   1, '2022-07-20'),
('Karan Mehta',    'karan.m@retailiq.in',   2, '2023-01-05'),
('Divya Reddy',    'divya.r@retailiq.in',   3, '2023-03-18');

-- Customers (30 customers)
INSERT INTO dim_customers (full_name, email, phone, gender, date_of_birth, city, region_id, registration_date, customer_segment) VALUES
('Rahul Gupta',       'rahul.g@mail.com',    '9810001111', 'Male',   '1990-05-14', 'Delhi',     1, '2021-03-10', 'VIP'),
('Anjali Singh',      'anjali.s@mail.com',   '9820002222', 'Female', '1992-08-22', 'Delhi',     1, '2021-07-15', 'Premium'),
('Suresh Kumar',      'suresh.k@mail.com',   '9830003333', 'Male',   '1985-12-01', 'Chennai',   2, '2022-01-20', 'Regular'),
('Meena Iyer',        'meena.i@mail.com',    '9840004444', 'Female', '1995-03-30', 'Bangalore', 2, '2022-04-05', 'Premium'),
('Amit Bose',         'amit.b@mail.com',     '9850005555', 'Male',   '1988-07-17', 'Kolkata',   3, '2021-11-11', 'Regular'),
('Ritika Sen',        'ritika.s@mail.com',   '9860006666', 'Female', '1993-01-09', 'Kolkata',   3, '2023-02-28', 'New'),
('Nikhil Jain',       'nikhil.j@mail.com',   '9870007777', 'Male',   '1991-09-25', 'Mumbai',    4, '2021-05-19', 'VIP'),
('Pooja Sharma',      'pooja.sh@mail.com',   '9880008888', 'Female', '1994-06-14', 'Pune',      4, '2022-08-30', 'Regular'),
('Deepak Yadav',      'deepak.y@mail.com',   '9890009999', 'Male',   '1987-11-03', 'Nagpur',    5, '2022-12-01', 'Regular'),
('Sunita Patil',      'sunita.p@mail.com',   '9900010000', 'Female', '1996-04-20', 'Bhopal',    5, '2023-01-15', 'New'),
('Manoj Tiwari',      'manoj.t@mail.com',    '9911011011', 'Male',   '1989-02-28', 'Lucknow',   1, '2021-09-09', 'Premium'),
('Kavita Verma',      'kavita.v@mail.com',   '9922022022', 'Female', '1997-07-07', 'Jaipur',    1, '2022-06-18', 'Regular'),
('Sanjay Nair',       'sanjay.n@mail.com',   '9933033033', 'Male',   '1984-10-15', 'Hyderabad', 2, '2021-04-04', 'VIP'),
('Lakshmi Rao',       'lakshmi.r@mail.com',  '9944044044', 'Female', '1993-12-22', 'Mysore',    2, '2022-09-27', 'Regular'),
('Gaurav Patel',      'gaurav.p@mail.com',   '9955055055', 'Male',   '1990-08-08', 'Ahmedabad', 4, '2021-12-31', 'Premium'),
('Rashmi Ghosh',      'rashmi.g@mail.com',   '9966066066', 'Female', '1995-05-16', 'Kolkata',   3, '2023-03-10', 'New'),
('Aryan Kapoor',      'aryan.k@mail.com',    '9977077077', 'Male',   '1992-03-04', 'Mumbai',    4, '2022-02-22', 'Regular'),
('Preethi Subbu',     'preethi.s@mail.com',  '9988088088', 'Female', '1991-11-30', 'Chennai',   2, '2021-08-08', 'Premium'),
('Varun Chopra',      'varun.c@mail.com',    '9999099099', 'Male',   '1986-06-19', 'Chandigarh',1, '2022-10-10', 'Regular'),
('Nisha Dubey',       'nisha.d@mail.com',    '8810010010', 'Female', '1998-02-14', 'Bhopal',    5, '2023-05-05', 'New'),
('Rohit Sinha',       'rohit.si@mail.com',   '8821021021', 'Male',   '1988-09-09', 'Patna',     3, '2022-11-20', 'Regular'),
('Kritika Agarwal',   'kritika.a@mail.com',  '8832032032', 'Female', '1994-04-04', 'Delhi',     1, '2021-06-30', 'Premium'),
('Sachin More',       'sachin.m@mail.com',   '8843043043', 'Male',   '1985-01-25', 'Nashik',    4, '2022-03-14', 'Regular'),
('Anusha Krishnan',   'anusha.k@mail.com',   '8854054054', 'Female', '1997-08-18', 'Coimbatore',2, '2023-04-20', 'New'),
('Tarun Bajaj',       'tarun.b@mail.com',    '8865065065', 'Male',   '1990-12-12', 'Delhi',     1, '2021-10-10', 'VIP'),
('Shruti Malhotra',   'shruti.m@mail.com',   '8876076076', 'Female', '1993-07-07', 'Gurgaon',   1, '2022-05-05', 'Regular'),
('Vishal Pandey',     'vishal.p@mail.com',   '8887087087', 'Male',   '1987-03-18', 'Varanasi',  5, '2022-07-25', 'Regular'),
('Neha Srivastava',   'neha.sr@mail.com',    '8898098098', 'Female', '1995-10-02', 'Lucknow',   1, '2023-06-01', 'New'),
('Akash Banerjee',    'akash.bn@mail.com',   '8909009009', 'Male',   '1991-05-28', 'Kolkata',   3, '2021-03-03', 'Premium'),
('Pallavi Desai',     'pallavi.d@mail.com',  '9010010010', 'Female', '1996-01-11', 'Surat',     4, '2022-09-09', 'Regular');

-- Orders (50 realistic orders across 2023–2024)
INSERT INTO fact_orders (customer_id, rep_id, order_date, ship_date, status, payment_method, discount_pct, shipping_cost, total_amount, region_id) VALUES
(1,  1, '2023-01-05 10:30:00', '2023-01-08', 'Delivered',   'Credit Card',  5.00, 0.00,  75049.05, 1),
(7,  4, '2023-01-12 14:22:00', '2023-01-15', 'Delivered',   'UPI',          0.00, 99.00, 29098.00, 4),
(11, 1, '2023-01-20 09:15:00', '2023-01-23', 'Delivered',   'Debit Card',   0.00, 0.00,  52999.00, 1),
(2,  6, '2023-02-03 11:45:00', '2023-02-07', 'Delivered',   'Credit Card',  10.0, 0.00,  25469.10, 1),
(13, 2, '2023-02-14 16:00:00', '2023-02-18', 'Delivered',   'Net Banking',  0.00, 0.00,  79999.00, 2),
(3,  2, '2023-02-28 13:20:00', '2023-03-03', 'Delivered',   'COD',          0.00, 150.00,3147.00,  2),
(25, 1, '2023-03-10 10:00:00', '2023-03-13', 'Delivered',   'Credit Card',  0.00, 0.00,  28999.00, 1),
(15, 4, '2023-03-22 15:30:00', '2023-03-26', 'Delivered',   'UPI',          5.00, 0.00,  59849.05, 4),
(5,  3, '2023-04-05 09:45:00', '2023-04-09', 'Delivered',   'Debit Card',   0.00, 99.00, 1898.00,  3),
(18, 2, '2023-04-18 14:10:00', '2023-04-22', 'Delivered',   'Credit Card',  0.00, 0.00,  62999.00, 2),
(7,  4, '2023-05-02 11:00:00', '2023-05-06', 'Delivered',   'Credit Card',  15.0, 0.00,  7224.15,  4),
(22, 1, '2023-05-15 10:30:00', '2023-05-19', 'Delivered',   'UPI',          0.00, 0.00,  4498.00,  1),
(9,  5, '2023-06-01 16:20:00', '2023-06-05', 'Delivered',   'COD',          0.00, 150.00,15149.00, 5),
(1,  1, '2023-06-18 12:00:00', '2023-06-22', 'Delivered',   'Credit Card',  10.0, 0.00,  7649.10,  1),
(4,  2, '2023-07-04 09:00:00', '2023-07-08', 'Delivered',   'Net Banking',  0.00, 0.00,  22999.00, 2),
(17, 4, '2023-07-20 14:50:00', '2023-07-24', 'Returned',    'Credit Card',  0.00, 0.00,  47999.00, 4),
(29, 3, '2023-08-03 10:15:00', '2023-08-07', 'Delivered',   'Debit Card',   5.00, 0.00,  1424.05,  3),
(13, 2, '2023-08-22 11:30:00', '2023-08-26', 'Delivered',   'UPI',          0.00, 0.00,  9998.00,  2),
(6,  3, '2023-09-10 15:45:00', '2023-09-14', 'Delivered',   'COD',          0.00, 99.00,  2398.00,  3),
(25, 1, '2023-09-25 09:30:00', '2023-09-29', 'Delivered',   'Credit Card',  20.0, 0.00,  63999.20, 1),
(10, 5, '2023-10-05 14:00:00', '2023-10-09', 'Delivered',   'UPI',          0.00, 0.00,   499.00,   5),
(7,  4, '2023-10-18 10:45:00', '2023-10-22', 'Delivered',   'Net Banking',  0.00, 0.00,  14999.00, 4),
(2,  6, '2023-11-02 16:10:00', '2023-11-06', 'Delivered',   'Credit Card',  0.00, 0.00,   8499.00,  1),
(11, 1, '2023-11-20 11:00:00', '2023-11-24', 'Delivered',   'UPI',          10.0, 0.00,  26999.10, 1),
(30, 4, '2023-12-05 09:15:00', '2023-12-09', 'Delivered',   'Debit Card',   0.00, 99.00,  5998.00,  4),
(1,  1, '2023-12-15 14:30:00', '2023-12-19', 'Delivered',   'Credit Card',  5.00, 0.00,  47499.05, 1),
(15, 4, '2023-12-26 10:00:00', '2023-12-30', 'Delivered',   'Credit Card',  0.00, 0.00,  28999.00, 4),
(3,  2, '2024-01-08 15:20:00', '2024-01-12', 'Delivered',   'COD',          0.00, 150.00, 22999.00, 2),
(20, 5, '2024-01-22 11:45:00', '2024-01-26', 'Processing',  'UPI',          0.00, 0.00,   799.00,   5),
(5,  3, '2024-02-10 09:00:00', '2024-02-14', 'Delivered',   'Net Banking',  0.00, 0.00,  52999.00, 3),
(13, 2, '2024-02-20 14:10:00', '2024-02-24', 'Delivered',   'Credit Card',  5.00, 0.00,  27549.05, 2),
(22, 1, '2024-03-01 16:30:00', '2024-03-05', 'Delivered',   'UPI',          0.00, 0.00,   1799.00,  1),
(29, 3, '2024-03-15 10:20:00', '2024-03-19', 'Cancelled',   'Debit Card',   0.00, 0.00,  62999.00, 3),
(7,  4, '2024-04-02 11:15:00', '2024-04-06', 'Delivered',   'Credit Card',  0.00, 0.00,  79999.00, 4),
(18, 2, '2024-04-20 14:50:00', '2024-04-24', 'Delivered',   'UPI',          10.0, 0.00,  44999.10, 2),
(4,  2, '2024-05-05 09:30:00', '2024-05-09', 'Delivered',   'Net Banking',  0.00, 0.00,   7499.00,  2),
(25, 1, '2024-05-18 15:00:00', '2024-05-22', 'Delivered',   'Credit Card',  0.00, 0.00,   1999.00,  1),
(1,  1, '2024-06-01 10:45:00', '2024-06-05', 'Delivered',   'Credit Card',  5.00, 0.00,  14249.05, 1),
(9,  5, '2024-06-15 14:20:00', '2024-06-19', 'Delivered',   'COD',          0.00, 99.00,  9099.00,  5),
(17, 4, '2024-07-03 11:30:00', '2024-07-07', 'Delivered',   'UPI',          0.00, 0.00,  22999.00, 4),
(2,  6, '2024-07-20 09:00:00', '2024-07-24', 'Delivered',   'Debit Card',   15.0, 0.00,  67499.15, 1),
(11, 1, '2024-08-05 16:10:00', '2024-08-09', 'Delivered',   'Credit Card',  0.00, 0.00,   2999.00,  1),
(30, 4, '2024-08-18 10:30:00', '2024-08-22', 'Delivered',   'Net Banking',  0.00, 0.00,  47999.00, 4),
(5,  3, '2024-09-02 15:45:00', '2024-09-06', 'Delivered',   'COD',          0.00, 150.00, 1499.00,  3),
(13, 2, '2024-09-20 11:00:00', '2024-09-24', 'Delivered',   'UPI',          5.00, 0.00,  52499.05, 2),
(22, 1, '2024-10-08 14:30:00', '2024-10-12', 'Delivered',   'Credit Card',  0.00, 0.00,  10999.00, 1),
(7,  4, '2024-10-25 09:15:00', '2024-10-29', 'Shipped',     'Credit Card',  0.00, 0.00,  28999.00, 4),
(29, 3, '2024-11-05 16:00:00', '2024-11-09', 'Delivered',   'Debit Card',   10.0, 0.00,  56699.10, 3),
(15, 4, '2024-11-28 10:15:00', '2024-12-02', 'Delivered',   'UPI',          20.0, 0.00,  47999.20, 4),
(1,  1, '2024-12-10 14:45:00', '2024-12-14', 'Delivered',   'Credit Card',  5.00, 0.00,   7124.05, 1);

-- Order Items
INSERT INTO fact_order_items (order_id, product_id, quantity, unit_price, unit_cost, discount_amt, line_total) VALUES
-- Order 1 (Electronics bundle)
(1,  2,  1, 79999, 55000, 4000.00, 75999),
-- Order 2
(2,  1,  1, 28999, 18000,     0,   28999),
-- Order 3
(3,  4,  1, 52999, 35000,     0,   52999),
-- Order 4 (Fashion)
(4,  9,  2, 1499,  600,    299.80, 2698),
(4,  11, 3, 1799,  700,    539.70, 5397),
-- Order 5
(5,  2,  1, 79999, 55000,     0,   79999),
-- Order 6 (Books)
(6,  19, 3, 499,   150,       0,   1497),
(6,  20, 2, 799,   350,       0,   1598),
-- Order 7
(7,  1,  1, 28999, 18000,     0,   28999),
-- Order 8
(8,  5,  1, 62999, 40000, 3150.00, 59849),
-- Order 9
(9,  18, 2, 1999,  800,       0,    3998),
-- Order 10
(10, 5,  1, 62999, 40000,     0,   62999),
-- Order 11 (Accessories)
(11, 7,  3, 1799,  800,  808.65,  4588),
(11, 8,  1, 8499,  4500, 1274.85, 7224),
-- Order 12
(12, 9,  1, 1499,  600,       0,   1499),
(12, 11, 1, 1799,  700,       0,   1799),
(12, 19, 2, 499,   150,       0,    998),
-- Order 13
(13, 16, 1, 14999, 8000,      0,   14999),
-- Order 14 (Shoes + Accessories)
(14, 17, 1, 5999,  2500,  600.00, 5399),
(14, 7,  1, 1799,  800,   180.00, 1619),
-- Order 15
(15, 3,  1, 22999, 15000,     0,   22999),
-- Order 16 (Returned laptop)
(16, 6,  1, 47999, 32000,     0,   47999),
-- Order 17
(17, 18, 1, 1999,  800,   149.93, 1849),
-- Order 18
(18, 13, 1, 7499,  4000,      0,   7499),
(18, 14, 1, 9999,  5500,      0,   9999),
-- Order 19
(19, 11, 1, 1799,  700,       0,   1799),
(19, 18, 1, 1999,  800,       0,   1999),
-- Order 20
(20, 5,  1, 62999, 40000, 12599.8, 50399),
(20, 7,  2, 1799,  800,    719.96, 2878),
-- Order 21
(21, 19, 1, 499,   150,       0,    499),
-- Order 22
(22, 16, 1, 14999, 8000,      0,   14999),
-- Order 23
(23, 8,  1, 8499,  4500,      0,   8499),
-- Order 24
(24, 3,  1, 22999, 15000, 2299.9,  20699),
(24, 9,  1, 1499,  600,       0,   1499),
-- Order 25
(25, 17, 2, 5999,  2500,      0,  11998),
-- Order 26
(26, 2,  1, 79999, 55000,     0,  79999),
-- Order 27 (Returned already - same product)
(27, 1,  1, 28999, 18000,     0,  28999),
-- Order 28
(28, 3,  1, 22999, 15000,     0,  22999),
-- Order 29
(29, 20, 1, 799,   350,       0,    799),
-- Order 30
(30, 4,  1, 52999, 35000,     0,  52999),
-- Order 31
(31, 2,  1, 79999, 55000,  4000,  75999),
-- Order 32
(32, 11, 1, 1799,  700,       0,   1799),
-- Order 33 (Cancelled)
(33, 5,  1, 62999, 40000,     0,  62999),
-- Order 34
(34, 2,  1, 79999, 55000,     0,  79999),
-- Order 35
(35, 6,  1, 47999, 32000, 4799.9, 43199),
-- Order 36
(36, 13, 1, 7499,  4000,      0,   7499),
-- Order 37
(37, 18, 1, 1999,  800,       0,   1999),
-- Order 38
(38, 16, 1, 14999, 8000,      0,  14999),
-- Order 39
(39, 13, 1, 7499,  4000,  749.9,   6749),
(39, 18, 2, 1999,  800,   399.8,   3598),
-- Order 40
(40, 3,  1, 22999, 15000,     0,  22999),
-- Order 41
(41, 2,  1, 79999, 55000,     0,  79999),
-- Order 42
(42, 10, 1, 2999,  1200,      0,   2999),
-- Order 43
(43, 6,  1, 47999, 32000,     0,  47999),
-- Order 44
(44, 9,  1, 1499,  600,       0,   1499),
-- Order 45
(45, 2,  1, 79999, 55000,  4000,  75999),
-- Order 46 (wait for next)
(46, 15, 1, 10999, 6000,      0,  10999),
-- Order 47
(47, 1,  1, 28999, 18000,     0,  28999),
-- Order 48
(48, 2,  1, 79999, 55000, 8000,   71999),
-- Order 49
(49, 6,  1, 47999, 32000,  4800,  43199),
-- Order 50
(50, 13, 1, 7499,  4000,   375,    7124);

-- Returns
INSERT INTO fact_returns (order_id, product_id, return_date, quantity, reason, refund_amount) VALUES
(16, 6, '2023-07-28', 1, 'Not Satisfied', 47999.00),
(33, 5, '2024-03-17', 1, 'Cancelled',     62999.00);
