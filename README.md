# 🇧🇷 Olist E-Commerce Data Pipeline

![dbt](https://img.shields.io/badge/dbt-Core%201.8-FF694B?logo=dbt&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.10+-blue?logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/Postgres-Database-336791?logo=postgresql&logoColor=white)
![Status](https://img.shields.io/badge/Pipeline-Production-green)

Proyek ini adalah simulasi **Modern Data Engineering Pipeline** menggunakan dataset publik [Brazilian E-Commerce by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). 

Tujuan utama proyek ini adalah membangun pipeline **ELT (Extract, Load, Transform)** yang mengubah data mentah yang berantakan menjadi **Star Schema** yang siap digunakan oleh Data Analyst untuk dashboard bisnis.

---

## 🏗️ Arsitektur Data

Alur data dalam proyek ini mengikuti prinsip **Medallion Architecture**:

1.  **Raw Layer (Seeds):** Data CSV mentah dari Kaggle dimuat ke database.
2.  **Staging Layer (Bronze):** Pembersihan tipe data, standarisasi nama kolom, dan perbaikan typo.
3.  **Intermediate Layer (Silver):** Logika bisnis kompleks, join antar tabel, dan kalkulasi metrik perantara.
4.  **Marts Layer (Gold):** Tabel final berbentuk **Fact & Dimensions** yang siap dikonsumsi BI Tools.





---

## 📚 Project Walkthrough (Business Logic)

Bagian ini menjelaskan logika transformasi data dari awal hingga akhir (*End-to-End*).

### 1. Data Ingestion & Cleaning (Staging Layer)
Langkah pertama adalah menstandarisasi data mentah yang masuk.

* **Handling Typo:** Memperbaiki nama kolom `product_name_lenght` menjadi `product_name_length`.
* **Type Casting:** Memastikan semua ID (Order ID, Customer ID) bertipe `STRING/VARCHAR` dan harga bertipe `NUMERIC`.
* **Date Parsing:** Mengubah string tanggal menjadi objek `TIMESTAMP` agar bisa dilakukan perhitungan selisih hari.

### 2. Complex Logic & Aggregation (Intermediate Layer)
Sebelum masuk ke tabel final, kita perlu menghitung total belanja per order. Karena satu Order ID bisa memiliki banyak item, kita melakukan agregasi di sini.

**File:** `int_order_payments.sql`
```sql
select
    order_id,
    sum(price) as total_item_value,           -- Total harga barang
    sum(freight_value) as total_freight_value, -- Total ongkir
    sum(price + freight_value) as total_order_value, -- Total Revenue
    count(order_item_id) as number_of_items    -- Jumlah barang dalam keranjang
from {{ ref('stg_items') }}
group by order_id
