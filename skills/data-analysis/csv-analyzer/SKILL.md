# CSV Data Analyzer

自动分析 CSV 文件，生成数据洞察和可视化。

## 激活场景

- 用户上传或提供 CSV 文件
- 用户说"分析数据"、"数据洞察"、"统计分析"
- 用户想了解数据的分布、趋势、异常

## 功能

1. 读取 CSV 文件结构
2. 识别列类型（数值/文本/日期）
3. 计算统计量
4. 发现数据模式
5. 生成分析报告

## 分析步骤

### 1. 数据概览

```bash
# 查看文件大小和行数
wc -l data.csv

# 查看前几行
head -5 data.csv

# 查看列名
head -1 data.csv
```

### 2. 使用 SQLite 分析

```sql
-- 导入 CSV
.mode csv
.import data.csv mytable

-- 查看结构
.schema mytable
PRAGMA table_info(mytable);

-- 行数统计
SELECT COUNT(*) FROM mytable;

-- 数值列统计
SELECT 
    MIN(column_name) as min,
    MAX(column_name) as max,
    AVG(column_name) as avg,
    COUNT(DISTINCT column_name) as unique_count
FROM mytable;

-- 分组统计
SELECT category, COUNT(*) as count
FROM mytable
GROUP BY category
ORDER BY count DESC;

-- 空值检查
SELECT COUNT(*) FROM mytable WHERE column_name IS NULL OR column_name = '';
```

### 3. 使用命令行工具

```bash
# 使用 awk 计算统计量
awk -F',' 'NR>1 {sum+=$3; count++} END {print "Average:", sum/count}' data.csv

# 使用 sort 和 uniq 统计分类
cut -d',' -f2 data.csv | sort | uniq -c | sort -rn

# 查找异常值
awk -F',' 'NR>1 && $3 > 1000 {print}' data.csv
```

## 分析维度

### 数值列

| 统计量 | 说明 |
|--------|------|
| count | 非空值数量 |
| mean | 平均值 |
| std | 标准差 |
| min | 最小值 |
| 25% | 第一四分位数 |
| 50% | 中位数 |
| 75% | 第三四分位数 |
| max | 最大值 |

### 文本列

| 统计量 | 说明 |
|--------|------|
| count | 非空值数量 |
| unique | 唯一值数量 |
| top | 出现最多的值 |
| freq | 最高频率 |

### 日期列

| 分析 | 说明 |
|------|------|
| 时间范围 | 最早到最晚 |
| 趋势 | 按时间聚合 |
| 周期性 | 按周/月分布 |

## 输出格式

### 分析报告

```markdown
# 数据分析报告

## 📊 数据概览

- **文件名**：sales_2024.csv
- **总行数**：10,234
- **列数**：8
- **文件大小**：1.2 MB

## 📋 列信息

| 列名 | 类型 | 非空率 | 唯一值 |
|------|------|--------|--------|
| date | 日期 | 100% | 365 |
| product | 文本 | 100% | 50 |
| amount | 数值 | 98% | 1,234 |
| region | 文本 | 100% | 5 |

## 📈 数值列统计

### amount 列
- 平均值：¥1,234.56
- 中位数：¥998.00
- 最小值：¥10.00
- 最大值：¥99,999.00
- 标准差：¥2,345.67

## 🔍 发现与洞察

1. **销售趋势**：Q4 销售额占全年 40%
2. **区域分布**：华东地区贡献最大（35%）
3. **异常值**：发现 3 笔超过 ¥50,000 的大额订单
4. **数据质量**：amount 列有 2% 的空值

## 💡 建议

- 调查大额订单的来源
- 补充缺失的 amount 数据
- 关注 Q1 销售下滑原因
```

## 常见分析场景

### 销售数据

- 总销售额、平均客单价
- 按时间/地区/产品分组
- 同比/环比增长

### 用户数据

- 用户总数、活跃用户
- 注册时间分布
- 用户行为分析

### 日志数据

- 错误率统计
- 响应时间分布
- 异常模式检测

## 注意事项

1. **大文件处理**：超过 100MB 的文件应分块处理
2. **编码问题**：注意检查文件编码（UTF-8/GBK）
3. **分隔符**：确认是逗号还是其他分隔符
4. **表头处理**：确认第一行是否为列名
5. **隐私保护**：注意脱敏敏感数据
