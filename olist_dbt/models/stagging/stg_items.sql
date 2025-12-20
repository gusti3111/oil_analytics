select
    order_id,
    product_id,
    seller_id,
    price,
    freight_value as ongkir
from {{ ref('raw_items') }}