with orders as (

  select * from {{ ref('stg_orders') }}

),

customers as (

  select * from {{ ref('stg_customers') }}

),

payments as (

  select * from {{ ref('stg_payments') }}
    --

),

completed_payments as (

  select 
      order_id, 
      max(created_at_date) as payment_finalized_date, 
      sum(amount_paid) as total_amount_paid
    from payments
    where payment_status <> 'fail'
    group by 1

),

paid_orders as (

  select 
    orders.order_id,
    orders.customer_id,
    orders.order_placed_at,
    orders.order_status,
    completed_payments.total_amount_paid,
    completed_payments.payment_finalized_date,
  from orders
  left join completed_payments on orders.order_id = completed_payments.order_id
  
),

final as (

  select
    paid_orders.*,
    customers.customer_first_name,
    customers.customer_last_name,
    row_number() over (
        order by paid_orders.order_id
    ) as transaction_seq,
    row_number() over (
        partition by paid_orders.customer_id 
        order by paid_orders.order_id
    ) as customer_sales_seq,
    case 
      when rank() over (partition by paid_orders.customer_id order by paid_orders.order_placed_at) = 1
      then 'new'
      else 'return'
    end as nvsr,
    sum(paid_orders.total_amount_paid) over (
        partition by paid_orders.customer_id
        order by paid_orders.order_placed_at
    ) as customer_lifetime_value,
    first_value(paid_orders.order_placed_at) over (
        partition by paid_orders.customer_id 
        order by paid_orders.order_placed_at
    ) as fdos
  from paid_orders
  left join customers on paid_orders.customer_id = customers.customer_id
  order by order_id
)

select * from final