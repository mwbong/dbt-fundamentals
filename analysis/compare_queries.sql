
{% set old_fct_orders_query=ref('customer_orders') %}

{% set new_fct_orders_query=ref('fct_customer_orders') %}
  

{{ audit_helper.compare_relations(
    a_relation=old_fct_orders_query,
    b_relation=new_fct_orders_query,
    primary_key="order_id"
) }}

