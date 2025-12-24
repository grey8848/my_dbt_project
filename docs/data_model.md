# 数仓建模设计文档（Data Model）

## 1. 设计目标

本数仓用于支持用户行为分析、订单分析与业务运营分析，遵循以下原则：

- 分层清晰：ODS / DIM / DWD / DWS / ADS
- 粒度明确：每张事实表粒度唯一
- 口径稳定：指标定义集中管理
- 可追溯：所有数据可追溯到 ODS

本数仓以 **订单流水（Order）** 与 **用户（User）** 为核心业务对象。

---

## 2. 分层说明

### 2.1 ODS（Operational Data Store）

**职责**
- 接收源系统原始数据
- 保留最细粒度
- 不做业务口径处理

**特点**
- 与源表 1:1 或近似 1:1
- 可支持数据回放、审计

---

### 2.2 DIM（Dimension）

**职责**
- 描述业务实体
- 提供稳定、可复用的分析维度
- 支持慢变（SCD）

**特点**
- 主键稳定
- 属性变化可追溯

---

### 2.3 DWD（Detail Fact）

**职责**
- 记录业务事件
- 一行 = 一个业务事实
- 通过维度外键关联 DIM

**特点**
- 粒度不可混合
- 是分析的事实基础层

---

### 2.4 DWS（Summary）

**职责**
- 按主题进行汇总
- 固化常用统计口径

---

### 2.5 ADS（Application）

**职责**
- 面向报表、接口、BI
- 可宽表、可反范式

---

## 3. 主题一：用户域（User Domain）

### 3.1 ODS 用户表

**表名**
- ods_user_di

**粒度**
- 一行 = 源系统一条用户记录

**字段**
| 字段名 | 说明 |
|------|------|
| user_id | 用户 ID |
| user_name | 用户名 |
| gender | 性别 |
| register_time | 注册时间 |
| status | 用户状态 |
| dt | 数据日期 |

---

### 3.2 DIM 用户维度表

**表名**
- dim_user

**粒度**
- 一行 = 一个用户（当前有效状态）

**字段**
| 字段名 | 说明 |
|------|------|
| user_id | 用户 ID（维度主键） |
| user_name | 用户名 |
| gender | 性别 |
| register_date | 注册日期 |
| user_status | 当前状态 |
| etl_date | 加工日期 |

---

## 4. 主题二：订单域（Order Domain）

### 4.1 ODS 订单流水表

**表名**
- ods_order_di

**粒度**
- 一行 = 一笔订单（源系统）

**字段**
| 字段名 | 说明 |
|------|------|
| order_id | 订单 ID |
| user_id | 用户 ID |
| order_amount | 订单金额 |
| order_status | 订单状态 |
| order_time | 下单时间 |
| dt | 数据日期 |

---

### 4.2 DWD 订单明细事实表

**表名**
- dwd_order_detail

**粒度**
- 一行 = 一笔订单行为

**关联维度**
- dim_user（user_id）

**字段**
| 字段名 | 说明 |
|------|------|
| order_id | 订单 ID |
| user_id | 用户 ID |
| order_amount | 订单金额 |
| order_status | 订单状态 |
| order_time | 下单时间 |
| dt | 业务日期 |

---

### 4.3 DWS 用户订单日汇总

**表名**
- dws_user_order_day

**粒度**
- 一行 = 用户 + 日期b

**指标**
| 指标 | 说明 |
|----|----|
| order_cnt | 下单次数 |
| order_amount_sum | 下单金额 |

---

### 4.4 ADS 用户画像宽表（示例）

**表名**
- ads_user_profile

**粒度**
- 一行 = 一个用户

**字段**
| 字段名 | 说明 |
|------|------|
| user_id | 用户 ID |
| total_order_cnt | 累计订单数 |
| total_order_amount | 累计消费金额 |
| first_order_date | 首单日期 |
| last_order_date | 最近下单日期 |

---

## 5. 建模约定

- 所有事实表必须声明粒度
- 不允许在 DWS / ADS 引入未声明口径
- 所有指标来源必须可追溯至 DWD

