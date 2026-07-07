# 📊 Sales Data Warehouse Analytics

An end-to-end SQL analytics project built on a retail sales data warehouse using Microsoft SQL Server and T-SQL.

The project walks through the complete analytics workflow — from setting up the database and exploring its structure, all the way to building reusable reporting views for customers and products. It covers exploratory data analysis (EDA), time-series trends, customer segmentation, product performance, and business KPIs.

---

## 🎯 What this project covers

- Setting up a data warehouse from raw CSV files
- Exploring database structure and understanding the data
- Calculating core business KPIs
- Analysing sales trends over time (monthly, quarterly, yearly)
- Ranking top and bottom performing products and customers
- Segmenting customers into VIP, Regular, and New tiers
- Building reusable SQL Views for customer and product reporting

---

## 📂 Project structure

```
Sales-Data-Warehouse-Analytics/
│
├── data/
│   ├── gold.dim_customers.csv      # 18,484 customer records
│   ├── gold.dim_products.csv       # 295 product records
│   └── gold.fact_sales.csv         # 60,398 sales transactions
│
├── sql/
│   ├── 00_init_database.sql        # Create DB, schema, tables, load data
│   ├── 01_database_exploration.sql # Explore table structure and row counts
│   ├── 02_dimensions_exploration.sql # Unique values across dimension tables
│   ├── 03_date_range_exploration.sql # Data time boundaries and age ranges
│   ├── 04_measures_exploration.sql   # Core KPIs: revenue, orders, customers
│   ├── 05_magnitude_analysis.sql     # Revenue and customers by dimension
│   ├── 06_ranking_analysis.sql       # Top/bottom products and customers
│   ├── 07_change_over_time_analysis.sql # Monthly and yearly sales trends
│   ├── 08_cumulative_analysis.sql    # Running totals and moving averages
│   ├── 09_performance_analysis.sql   # Year-over-year product performance
│   ├── 10_data_segmentation.sql      # Product cost tiers, customer segments
│   ├── 11_part_to_whole_analysis.sql # Revenue share by category, country
│   ├── 12_report_customers.sql       # Customer reporting view
│   └── 13_report_products.sql        # Product reporting view
│
└── README.md
```

---

## 🗄️ Dataset overview

| Table | Rows | Description |
|---|---|---|
| `gold.dim_customers` | 18,484 | Customer demographics across 6 countries |
| `gold.dim_products` | 295 | Product catalog across 4 categories |
| `gold.fact_sales` | 60,398 | Sales transactions from 2010 to 2014 |

**Key numbers from the data:**
- Total revenue: **$29.4 million**
- Total unique orders: **27,659**
- Date range: **2010 – 2014**
- Top markets: **United States ($9.2M)** and **Australia ($9.1M)**
- Top category: **Bikes (96% of revenue)**

---

## 🛠️ Tech stack

- **Microsoft SQL Server** — database engine
- **T-SQL** — query language
- **SQL Server Management Studio (SSMS)** — development environment
- **Git & GitHub** — version control

---

## 📈 SQL concepts used

| Concept | Where applied |
|---|---|
| `JOIN` | Linking fact and dimension tables |
| `GROUP BY` / `HAVING` | Aggregating sales by dimension |
| `CASE` | Segmentation logic, trend flags |
| `CTEs` | Multi-step queries in scripts 09–13 |
| `Window Functions` | Running totals, rankings, YoY with `LAG()` |
| `RANK()` / `DENSE_RANK()` | Product and customer rankings |
| `SUM() OVER()` / `AVG() OVER()` | Cumulative analysis |
| `DATETRUNC()` / `FORMAT()` | Date grouping for trend analysis |
| `DATEDIFF()` | Age, lifespan, and recency calculations |
| `Views` | Reusable reporting layer (scripts 12–13) |
| `BULK INSERT` | Loading CSV data into SQL Server |

---

## ⚙️ How to run

**Prerequisites:**
- Microsoft SQL Server (Express edition is free)
- SQL Server Management Studio (SSMS)

**Steps:**

1. Clone this repository:
```bash
git clone https://github.com/DhruvSharma0611/Sales-Data-Warehouse-Analytics.git
```

2. Open `00_init_database.sql` in SSMS

3. Update the three CSV file paths in the `BULK INSERT` blocks to match your local machine:
```sql
-- Change this line in 00_init_database.sql:
FROM 'C:\sql\datasets\csv-files\gold.dim_customers.csv'

-- To wherever your CSV files are saved, for example:
FROM 'C:\Users\YourName\Downloads\data\gold.dim_customers.csv'
```

4. Run `00_init_database.sql` — this creates the database and loads all data

5. Run scripts `01` through `13` in order

---

## 💡 Key insights from the analysis

- **Bikes dominate revenue** — they make up 96% of total sales despite being just one of four categories
- **US and Australia** together account for over 60% of all revenue
- **2013 was the strongest year** — revenue hit $16.3M, more than double 2012
- **Mountain-200 series** are the top-performing products across multiple variants
- **VIP customers** (12+ months, $5K+ spend) drive a disproportionate share of revenue

---

## 👨‍💻 Author

**Dhruv Sharma**
Aspiring Data Analyst with a focus on SQL, Business Intelligence, and Data Analytics.

- 🔗 GitHub: [github.com/DhruvSharma0611](https://github.com/DhruvSharma0611)
- 💼 LinkedIn: [linkedin.com/in/dhruv-sharma-006939289](https://www.linkedin.com/in/dhruv-sharma-006939289/)
