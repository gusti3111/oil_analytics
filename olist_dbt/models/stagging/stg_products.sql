with source as (
    -- Mengambil data mentah dari seed/csv
    select * from {{ ref('raw_products') }}
),

renamed as (
    select
        -- ID harus string (varchar)
        cast(product_id as string) as product_id,
        
        -- Kategori produk (Bahasa Portugis)
        cast(product_category_name as string) as product_category_name,
        
        -- PERBAIKAN TYPO (Data asli Kaggle tulisannya 'lenght')
        cast(product_name_lenght as integer) as product_name_length,
        cast(product_description_lenght as integer) as product_description_length,
        
        -- Metrics Fisik (Pastikan jadi angka/numeric)
        cast(product_photos_qty as integer) as product_photos_qty,
        cast(product_weight_g as numeric) as product_weight_g,
        cast(product_length_cm as numeric) as product_length_cm,
        cast(product_height_cm as numeric) as product_height_cm,
        cast(product_width_cm as numeric) as product_width_cm

    from source
)

select * from renamed