# 编程项目工作流示例

> 使用 `programming-workflow` 技能从 0 到 1 完成一个项目

## 📋 场景说明

**项目**: 创建一个新的 API 服务
**阶段**: 需求 → 架构 → 开发 → 测试 → 部署
**技能组合**: programming-workflow + planning-with-files + test-driven-development

---

## 🚀 完整流程示例

### 阶段 1: 需求探索 (Day 1)

```
用户：我想创建一个新的 API 服务，用于管理知识库文档。

小熊：好的！让我先用 `programming-workflow` 技能帮你规划整个项目。🐻

📊 **项目阶段分析**

根据 programming-workflow 的 9 阶段流程：

1. ✅ 需求阶段 ← 当前阶段
2. ⏳ 产品设计
3. ⏳ UI 设计
4. ⏳ 架构设计
5. ⏳ 开发实现
6. ⏳ 测试验证
7. ⏳ 部署上线
8. ⏳ 运营监控

让我先帮你明确需求：
- 目标用户是谁？
- 核心功能有哪些？
- 技术栈有什么要求？
```

**输出**: `projects/knowledge-api/requirements.md`

```markdown
# 知识库 API 需求文档

## 目标用户
- AI 助手（小琳、小猪、小熊）
- 知识库维护人员

## 核心功能
1. 文档 CRUD 操作
2. 全文搜索（FTS5）
3. 版本管理
4. 权限控制

## 技术栈
- Node.js + Express
- SQLite (WAL 模式)
- JWT 认证
```

---

### 阶段 2: 创建任务计划 (Day 1)

```
用户：需求明确了，接下来怎么做？

小熊：让我用 `planning-with-files` 创建详细的任务计划：

📝 **创建任务看板**
- task_plan.md - 总体计划
- findings.md - 技术调研记录
- progress.md - 进度追踪

需要我现在创建吗？
```

**输出**: `projects/knowledge-api/task_plan.md`

```markdown
# 知识库 API 项目计划

## 阶段 1: 需求 (完成)
- [x] 需求调研
- [x] 编写需求文档

## 阶段 2: 产品 (进行中)
- [ ] 功能列表
- [ ] 用户故事

## 阶段 3: UI 设计
- [ ] API 文档设计
- [ ] 错误码规范

## 阶段 4: 架构
- [ ] 目录结构设计
- [ ] 数据库设计
- [ ] 接口设计

## 阶段 5: 开发
- [ ] 项目初始化
- [ ] 实现 CRUD
- [ ] 实现搜索
- [ ] 实现认证

## 阶段 6: 测试
- [ ] 单元测试
- [ ] 集成测试
- [ ] 端到端测试

## 阶段 7: 部署
- [ ] Docker 化
- [ ] CI/CD配置
- [ ] 生产部署

## 阶段 8: 运营
- [ ] 监控配置
- [ ] 日志收集
```

---

### 阶段 3: 架构设计 (Day 2)

```
用户：开始架构设计吧。

小熊：好的！根据 `project-standards` 的目录组织决策树：

📁 **推荐的目录结构**

knowledge-api/
├── src/
│   ├── routes/         # API 路由
│   ├── controllers/    # 业务逻辑
│   ├── models/         # 数据模型
│   ├── middleware/     # 中间件
│   └── utils/          # 工具函数
├── tests/
│   ├── unit/           # 单元测试
│   └── integration/    # 集成测试
├── docs/
│   └── api.md          # API 文档
├── scripts/
│   └── init-db.sql     # 数据库初始化
└── config/
    └── default.json    # 配置文件

需要我帮你初始化项目吗？
```

---

### 阶段 4: 测试驱动开发 (Day 3-5)

```
用户：开始写代码吧。

小熊：建议使用 `test-driven-development` 技能：

🔄 **TDD 流程**
1. 先写失败的测试
2. 实现最小功能
3. 运行测试通过
4. 重构优化

从哪个功能开始？
- [ ] 文档创建
- [ ] 文档查询
- [ ] 全文搜索
- [ ] 用户认证
```

**输出**: `tests/unit/document.test.js`

```javascript
const request = require('supertest');
const app = require('../../src/app');

describe('文档 API', () => {
  describe('POST /api/documents', () => {
    it('应该成功创建文档', async () => {
      const doc = {
        title: '测试文档',
        content: '这是测试内容'
      };
      
      const res = await request(app)
        .post('/api/documents')
        .send(doc);
      
      expect(res.statusCode).toBe(201);
      expect(res.body.success).toBe(true);
      expect(res.body.data.id).toBeDefined();
    });
  });
});
```

---

### 阶段 5: 代码审查 (Day 6)

```
用户：代码写完了，帮我审查一下。

小熊：使用 `requesting-code-review` 技能：

🔍 **代码审查清单**

**代码质量**
- [ ] ESLint 检查通过
- [ ] TypeScript 类型正确
- [ ] 函数长度合理 (<50 行)

**测试覆盖**
- [ ] 单元测试覆盖率 >80%
- [ ] 边界情况已测试
- [ ] 错误处理完整

**安全**
- [ ] SQL 注入防护
- [ ] XSS 防护
- [ ] 认证授权正确

需要我详细审查哪个文件？
```

---

### 阶段 6: 部署上线 (Day 7)

```
用户：准备部署了。

小熊：使用 `deploying-applications` 技能：

🚀 **部署检查清单**

**环境准备**
- [ ] 生产环境变量配置
- [ ] 数据库迁移完成
- [ ] SSL 证书配置

**部署步骤**
1. 构建生产版本
   ```bash
   npm run build
   ```

2. Docker 构建
   ```bash
   docker build -t knowledge-api .
   ```

3. 启动服务
   ```bash
   docker-compose up -d
   ```

4. 健康检查
   ```bash
   curl http://localhost:3000/health
   ```

需要我帮你执行部署吗？
```

---

## 📊 进度追踪

### 每日同步

```bash
# 更新进度文件
cat >> projects/knowledge-api/progress.md << EOF

## $(date +%Y-%m-%d)
- 完成：XXX
- 问题：XXX
- 明日计划：XXX
EOF
```

### 阶段验收

| 阶段 | 验收标准 | 状态 |
|------|---------|------|
| 需求 | 需求文档完成 | ✅ |
| 产品 | 功能列表确认 | ✅ |
| 架构 | 目录结构确定 | ✅ |
| 开发 | 所有功能实现 | ⏳ |
| 测试 | 覆盖率>80% | ⏳ |
| 部署 | 服务可访问 | ⏳ |

---

## 💡 使用技巧

### 技巧 1: 阶段明确
- 每个阶段有明确的输入输出
- 不跳阶段，保证质量

### 技巧 2: 文档先行
- 先写文档再写代码
- 文档是契约，代码是实现

### 技巧 3: 测试驱动
- 先写测试再实现功能
- 保证代码质量

### 技巧 4: 持续同步
- 每天更新进度文件
- 问题及时记录和解决

---

## 🔗 相关技能

- `planning-with-files` - 任务计划管理
- `test-driven-development` - 测试驱动开发
- `requesting-code-review` - 代码审查
- `deploying-applications` - 应用部署
- `project-standards` - 项目规范

---

*示例版本：v1.0*
*更新时间：2026-03-14*
