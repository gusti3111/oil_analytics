with orders as (
    select * from {{ ref('stg_orders') }}
),

payments as (
    select 
        order_id, 
        sum(payment_value) as total_payment 
    from {{ ref('stg_payments') }}
    group by 1
)

select
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_at,
    p.total_payment
from orders o
left join payments p using (order_id)
where o.order_status = 'delivered' -- Kita hanya menghitung order yang sukses