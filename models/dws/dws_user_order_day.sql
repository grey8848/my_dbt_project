select
    user_id,
    dt,
    count(*) as order_cnt,
    sum(order_amount) as order_amount_sum
from {{ ref('dwd_order_detail') }}
group by user_id, dt
