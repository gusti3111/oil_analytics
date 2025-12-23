# Oilist: Data Transformation Pipeline

![dbt Core](https://img.shields.io/badge/dbt-Core%201.8-FF694B?logo=dbt&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.10+-blue?logo=python&logoColor=white)
![Status](https://img.shields.io/badge/Pipeline-Production-green)
![License](https://img.shields.io/badge/License-Proprietary-lightgrey)

**Oilist** adalah proyek transformasi data (ELT) berbasis **dbt (data build tool)** yang dirancang untuk memproses, membersihkan, dan memodelkan data operasional perkebunan. Proyek ini mengubah data mentah dari berbagai sumber (sensor IoT, laporan panen manual, data cuaca) menjadi wawasan bisnis yang siap dianalisis.

## 🏗️ Arsitektur Data

Pipeline ini mengikuti pola arsitektur **Modern Data Stack**:
1.  **Extract & Load:** Data di-load ke Data Warehouse (Raw Layer) menggunakan *Airbyte/Fivetran*.
2.  **Transform (Oilist):** dbt mengambil alih untuk transformasi data di dalam warehouse.
3.  **Analyze:** Data yang sudah bersih dikonsumsi oleh BI Tools (Superset/Metabase/Tableau).

### Data Lineage Layers
Proyek ini distrukturisasi ke dalam 3 layer utama (Medallion Architecture):

* **🥉 Bronze (Staging):** View 1:1 dengan source, cleaning dasar, renaming kolom (`stg_`).
* **🥈 Silver (Intermediate):** Logika bisnis kompleks, joins antar tabel, agregasi level menengah (`int_`).
* **🥇 Gold (Marts):** Model final berbentuk Star Schema (Facts & Dimensions) siap untuk dashboard (`fct_`, `dim_`).

## 📂 Struktur Direktori

```text
oilist/
├── analysis/               # Query SQL ad-hoc untuk investigasi data
├── macros/                 # Fungsi Jinja custom (DRY principle)
│   └── generate_schema_name.sql
├── models/
│   ├── staging/            # Layer Pembersihan (Bronze)
│   │   ├── _schema.yml     # Dokumentasi & Tes source
│   │   └── stg_harvests.sql
│   ├── intermediate/       # Layer Logika (Silver)
│   │   └── int_yield_analysis.sql
│   └── marts/              # Layer Bisnis (Gold)
│   │   ├── core/           # Dimensi utama (dim_locations, dim_workers)
│   │   └── operations/     # Transaksi (fct_monthly_production)
├── seeds/                  # Data statis (Mapping pupuk, Kode area)
├── snapshots/              # Type 2 SCD (History perubahan harga/aset)
├── tests/                  # Singular data tests
└── dbt_project.yml         # Konfigurasi project root



