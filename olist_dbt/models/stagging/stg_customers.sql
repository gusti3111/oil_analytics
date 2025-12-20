select
    customer_id,
    customer_unique_id, -- Olist membedakan ID transaksi vs ID unik user
    customer_city,
    customer_state
from {{ ref('raw_customers') }}