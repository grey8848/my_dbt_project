select
    user_id,
    user_name,
    gender,
    date(register_time) as register_date,
    status as user_status,
    current_date() as etl_date
from {{ ref('ods_user') }}
