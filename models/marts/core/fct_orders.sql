with orders as (
    select * from {{ ref('stg_orders') }}
),
payments as (
    select * from {{ ref('stg_payments') }}
),
order_payments as (
    select
        orders.order_id,
        orders.customer_id,
        sum(case when payments.status = 'success' then payments.amount end) as amount
    from orders left outer join payments on orders.order_id = payments.order_id
    group by orders.order_id, orders.customer_id
),
final as (
    select 
        order_id,
        customer_id,
        coalesce(amount,0) as amount
    from order_payments
)
select * from final