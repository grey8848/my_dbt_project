select
    cast(user_id as bigint) as user_id,
    user_name,
    gender,
    register_time,
    status,
    '{{ var("biz_date") }}' as dt
from source_mysql.user
where dt = '{{ var("biz_date") }}'
