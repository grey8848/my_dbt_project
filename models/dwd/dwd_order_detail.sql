select
    o.order_id,
    o.user_id,
    o.order_amount,
    o.order_status,
    o.order_time,
    o.dt
from {{ ref('ods_order') }} o
