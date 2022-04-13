select
    id as payment_id,
    orderid as order_id,
    paymentmethod as payment_method,
    status,
    created as created_at,
    amount/100 as amount
from mineral-origin-347001.jaffle_shop.payment