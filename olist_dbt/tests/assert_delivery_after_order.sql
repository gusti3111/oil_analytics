-- Jika query ini mengembalikan hasil, berarti test GAGAL (ada data error)
select order_id
from {{ ref('stg_orders') }}
where delivered_at < order_at