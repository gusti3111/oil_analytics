with products as (
    -- Ambil data produk yang sudah dibersihkan di staging
    select * from {{ ref('stg_products') }}
),

translations as (
    -- Ambil data terjemahan (Portugis -> Inggris)
    -- Pastikan Anda sudah melakukan 'dbt seed' untuk file ini
    select * from {{ ref('category_translation') }}
),

final as (
    select
        products.product_id,
        
        -- CLEANING 1: Menggabungkan dengan terjemahan
        -- Jika ada terjemahan Inggris, pakai itu. 
        -- Jika tidak ada, pakai nama asli (Portugis).
        -- Jika nama asli null, ganti jadi 'Uncategorized'.
        coalesce(translations.product_category_name_english, products.product_category_name, 'Uncategorized') as category_name,
        
        -- Simpan nama asli untuk referensi (opsional)
        products.product_category_name as category_original_name,
        
        -- CLEANING 2: Merapikan Metrics Fisik (Handling Null dengan 0)
        coalesce(products.product_weight_g, 0) as weight_g,
        coalesce(products.product_length_cm, 0) as length_cm,
        coalesce(products.product_height_cm, 0) as height_cm,
        coalesce(products.product_width_cm, 0) as width_cm,
        
        -- Metrics Lainnya
        products.product_photos_qty

    from products
    -- Gunakan LEFT JOIN karena kita ingin SEMUA produk tampil, 
    -- meskipun tidak punya terjemahan.
    left join translations 
        on products.product_category_name = translations.product_category_name
)

select * from final