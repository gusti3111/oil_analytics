with orders as (
    select * from {{ ref('fct_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
)

select
    c.customer_unique_id,
    c.customer_city,
    
    -- Frequency
    count(o.order_id) as frequency,
    
    -- Monetary
    sum(o.total_payment) as monetary,
    
    -- Recency (Asumsikan hari ini adalah tanggal max di dataset: 2018-10-17)
    -- DuckDB function: date_diff('day', start, end)
    min(date_diff('day', o.order_at, CAST('2018-10-17' AS TIMESTAMP))) as recency_days

from customers c
join orders o using (customer_id)
group by 1, 2