select
    order_id,
    customer_id,
    order_status,
    -- Casting string ke Timestamp
    cast(order_purchase_timestamp as timestamp) as order_at,
    cast(order_delivered_customer_date as timestamp) as delivered_at
from {{ ref('raw_orders') }}