Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices



1. 新增 snapshot 捕获用户变化

  - snapshots/snapshot_user.sql: 使用 timestamp 策略跟踪 user_name、gender、status 字段的变化，以 dt（业务日期）作为变化时间戳。

  2. 升级 dim_user 为 SCD2 结构

  - models/dim/dim_user.sql: 现在基于 snapshot 构建，包含：
    - user_key: 代理键（snapshot 自动生成的 dbt_scd_id）
    - 有效日期范围：valid_from、valid_to
    - is_current: 当前记录标志
    - 保留原有维度属性 + 注册日期

  3. 添加模型文档和测试

  - models/dim/schema.yml: 定义列描述和基础数据测试（not_null、unique）。

  4. 项目配置更新

  - dbt_project.yml: 添加 biz_date 变量默认值（2025-12-24）。

  5. 临时修复编译依赖

  - models/ods/ods_order.sql: 创建占位符模型，解决 dwd_order_detail 的编译依赖问题。

  🔧 使用说明

  首次运行 SCD2

  # 1. 检查配置
  dbt debug

  # 2. 创建用户历史快照（首次会创建初始版本）
  dbt snapshot

  # 3. 构建 SCD2 维度表
  dbt run --select dim_user

  # 4. 运行数据测试
  dbt test --select dim_user

  日常更新

  - 数据变化时：snapshot 会自动检测 user_name、gender、status 的变化并创建新版本
  - 查询当前有效记录：SELECT * FROM dim_user WHERE is_current = true
  - 查询历史记录：SELECT * FROM dim_user WHERE user_id = ? ORDER BY valid_from

  ⚠️ 注意事项

  1. 数据源依赖：ods_user 需要能访问 source_mysql.user 表，否则 snapshot 会失败
  2. 业务日期：biz_date 变量可在运行时覆盖：dbt run --vars '{"biz_date": "2025-12-25"}'
  3. StarRocks 适配器：当前使用 timestamp 策略，如需更精确的变化检测可考虑自定义 SCD2 逻辑
  4. 测试扩展：schema.yml 中的测试可进一步扩展，如添加唯一性约束测试

  📊 SCD2 字段说明

  | 字段                | 类型     | 说明                 |
  |---------------------|----------|----------------------|
  | user_key            | 代理键   | 唯一标识每条历史记录 |
  | user_id             | 自然键   | 用户业务ID           |
  | valid_from/valid_to | 日期时间 | 记录有效时间范围     |
  | is_current          | 布尔值   | 是否当前有效记录     |
  | snapshot_at         | 日期时间 | snapshot 处理时间    |

  现在 dim_user 已具备完整的 SCD2 能力，可以跟踪用户属性的历史变化