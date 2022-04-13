with customers as (
    select * from {{ ref('dim_customers') }}
),
orders as (
    select * from {{ ref('fct_orders') }}
),
final as (
    select
        customers.first_name,
        customers.last_name,
        orders.order_id,
        amount,
        customers.most_recent_order_date,
        customers.number_of_orders
    from orders
    left join customers using (customer_id)
)
select * from final