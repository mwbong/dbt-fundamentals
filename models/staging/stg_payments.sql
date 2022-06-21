with payments as (

    select 
      orderid as order_id, 
      created as created_at_date, 
      amount / 100.0 as amount_paid,
      status as payment_status
    from {{ source('jaffle_shop', 'payment') }}

)

select * from payments