---
name: diagram-generator
description: Mermaid 绘图技能。用于生成流程图、时序图、架构图、类图、ER图、状态图、甘特图、饼图等。当需要可视化流程、系统架构、数据关系时使用。
---

# Mermaid 绘图技能

使用 Mermaid 生成各类图表，适用于技术文档、架构设计、流程说明等场景。

## 支持的图表类型

| 类型 | 语法 | 适用场景 |
|:-----|:-----|:---------|
| 流程图 | `flowchart` | 业务流程、算法逻辑 |
| 时序图 | `sequenceDiagram` | API 交互、消息流程 |
| 类图 | `classDiagram` | 数据模型、OOP 设计 |
| ER 图 | `erDiagram` | 数据库设计 |
| 状态图 | `stateDiagram-v2` | 状态机、生命周期 |
| 甘特图 | `gantt` | 项目进度、时间线 |
| 饼图 | `pie` | 数据分布、占比 |
| 架构图 | `C4Context` | 系统架构 |

---

## 流程图（Flowchart）

### 基本语法

```mermaid
flowchart TD
    A[开始] --> B{条件判断}
    B -->|是| C[执行操作]
    B -->|否| D[其他操作]
    C --> E[结束]
    D --> E
```

### 方向

| 方向 | 说明 |
|:-----|:-----|
| `TD` / `TB` | 从上到下 |
| `BT` | 从下到上 |
| `LR` | 从左到右 |
| `RL` | 从右到左 |

### 节点形状

```mermaid
flowchart LR
    A[矩形] --> B(圆角矩形)
    B --> C([体育场形])
    C --> D[[子程序]]
    D --> E[(数据库)]
    E --> F((圆形))
    F --> G>旗帜形]
    G --> H{菱形}
    H --> I{{六边形}}
```

### 样式

```mermaid
flowchart LR
    A[节点A] --> B[节点B]
    
    style A fill:#10B981,color:white,stroke:#059669
    style B fill:#2563EB,color:white,stroke:#1d4ed8
```

---

## 时序图（Sequence Diagram）

### 基本语法

```mermaid
sequenceDiagram
    participant U as 用户
    participant S as 服务器
    participant D as 数据库
    
    U->>S: 发送请求
    activate S
    S->>D: 查询数据
    D-->>S: 返回结果
    S-->>U: 响应数据
    deactivate S
```

### 箭头类型

| 箭头 | 说明 |
|:-----|:-----|
| `->` | 实线无箭头 |
| `-->` | 虚线无箭头 |
| `->>` | 实线带箭头 |
| `-->>` | 虚线带箭头 |
| `-x` | 实线带叉 |
| `--x` | 虚线带叉 |

### 循环和条件

```mermaid
sequenceDiagram
    participant A as 客户端
    participant B as 服务器
    
    loop 每秒
        A->>B: 心跳检测
        B-->>A: 响应
    end
    
    alt 成功
        B-->>A: 200 OK
    else 失败
        B-->>A: 500 Error
    end
```

---

## 类图（Class Diagram）

```mermaid
classDiagram
    class Animal {
        +String name
        +int age
        +makeSound()
    }
    class Dog {
        +String breed
        +bark()
    }
    class Cat {
        +meow()
    }
    
    Animal <|-- Dog
    Animal <|-- Cat
```

---

## ER 图（Entity Relationship）

```mermaid
erDiagram
    USER ||--o{ ORDER : places
    ORDER ||--|{ ORDER_ITEM : contains
    PRODUCT ||--o{ ORDER_ITEM : includes
    
    USER {
        int id PK
        string name
        string email
    }
    ORDER {
        int id PK
        int user_id FK
        datetime created_at
    }
```

---

## 状态图（State Diagram）

```mermaid
stateDiagram-v2
    [*] --> 待处理
    待处理 --> 进行中: 开始
    进行中 --> 已完成: 完成
    进行中 --> 已取消: 取消
    已完成 --> [*]
    已取消 --> [*]
```

---

## 甘特图（Gantt）

```mermaid
gantt
    title 项目进度
    dateFormat  YYYY-MM-DD
    
    section 第一阶段
    需求分析    :a1, 2024-01-01, 7d
    系统设计    :a2, after a1, 5d
    
    section 第二阶段
    开发实现    :b1, after a2, 14d
    测试验收    :b2, after b1, 7d
```

---

## 饼图（Pie）

```mermaid
pie title 技术栈分布
    "JavaScript" : 40
    "Python" : 30
    "Go" : 20
    "其他" : 10
```

---

## 生成图片

### 安装工具

```bash
npm install -g @mermaid-js/mermaid-cli
```

### 生成命令

```bash
# 生成 PNG
mmdc -i diagram.mmd -o diagram.png

# 生成 SVG（推荐）
mmdc -i diagram.mmd -o diagram.svg

# WSL 环境
PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser mmdc -i diagram.mmd -o diagram.png
```

### Puppeteer 配置

```json
// puppeteer-config.json
{
  "args": ["--no-sandbox", "--disable-setuid-sandbox"]
}
```

```bash
mmdc -i diagram.mmd -o diagram.png -p puppeteer-config.json
```

---

## 常见问题

### Q: 中文乱码
**A**: 安装中文字体
```bash
sudo apt-get install fonts-wqy-microhei
fc-cache -fv
```

### Q: 找不到 Chromium
**A**: 安装并设置环境变量
```bash
sudo apt-get install chromium-browser
export PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
```

---

*技能作者：小琳 ✨*
