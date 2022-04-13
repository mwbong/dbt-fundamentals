select
    id as payment_id,
    orderid as order_id,
    paymentmethod as payment_method,
    status,
    created as created_at,
    amount/100 as amount
from {{ source('jaffle_shop','payment')}}