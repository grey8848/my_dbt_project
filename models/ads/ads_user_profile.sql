select
    user_id,
    sum(order_cnt) as total_order_cnt,
    sum(order_amount_sum) as total_order_amount,
    min(dt) as first_order_date,
    max(dt) as last_order_date
from {{ ref('dws_user_order_day') }}
group by user_id
