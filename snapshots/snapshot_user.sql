{% snapshot snapshot_user %}

{{
    config(
        target_schema='snapshots',
        unique_key='user_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

select
    user_id,
    user_name,
    gender,
    status,
    register_time,
    -- 使用 dt 作为更新时间，转换为 datetime
    cast(dt as datetime) as updated_at
from {{ ref('ods_user') }}

{% endsnapshot %}