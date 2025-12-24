select
    -- 代理键，snapshot 自动生成
    dbt_scd_id as user_key,
    -- 自然键
    user_id,
    -- 维度属性
    user_name,
    gender,
    status as user_status,
    -- 注册日期（不变属性）
    date(register_time) as register_date,
    -- 有效日期范围
    dbt_valid_from as valid_from,
    dbt_valid_to as valid_to,
    -- 当前记录标志
    case when dbt_valid_to is null then true else false end as is_current,
    -- 元数据
    dbt_updated_at as snapshot_at
from {{ ref('snapshot_user') }}
