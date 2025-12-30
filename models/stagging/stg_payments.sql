select
    order_id,
    payment_type,
    payment_value,
    payment_installments as cicilan
from {{ ref('raw_payments') }}