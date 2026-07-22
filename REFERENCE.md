# Git Commit 提交规范（团队统一版）

统一团队 Commit 风格，提高代码可读性、可追溯性与协作效率。

---

## 1. 目的

为保证团队代码提交记录：

- ✅ 清晰可读
- ✅ 易于追溯
- ✅ 方便 Code Review
- ✅ 方便问题排查

所有开发人员必须统一使用本规范提交 Commit。

---

## 2. Commit 标准格式

```
<type>(<scope>): <summary>

<body>

Refs: <issue-id>  // 可选
```

### 标准示例

```
fix(支付模块): 修复微信支付回调重复入账问题

- 增加支付回调幂等校验
- 使用 transaction_id 防止重复处理
- 补充支付回调测试用例

Refs: BUG-1024
```

---

## 3. 提交类型（type）

用于说明本次提交的性质。

| 类型 | 说明 |
|------|------|
| feat | 新功能 |
| fix | 修复问题 |
| refactor | 代码重构 |
| perf | 性能优化 |
| test | 测试相关 |
| docs | 文档修改 |
| style | 格式调整（不影响逻辑） |
| chore | 构建、配置、依赖等杂项 |

---

## 4. 模块范围（scope）

用于说明本次提交影响的模块或业务范围。推荐直接使用中文 scope。

| 推荐 scope | 英文参考 |
|------------|---------|
| 登录认证 | login/auth |
| 用户模块 | user |
| 支付模块 | payment |
| 订单模块 | order |
| 管理后台 | admin |
| 接口服务 | api |
| 网关服务 | gateway |
| 缓存模块 | cache |
| 消息通知 | notification |
| 文件上传 | upload |
| 配置管理 | config |
| 数据库 | database |
| 定时任务 | cron/scheduler |
| 日志模块 | log |
| 短信模块 | sms |
| 邮件模块 | email |
| 搜索模块 | search |
| 报表模块 | report |
| AI 功能 | ai |
| 页面 UI | ui |
| 移动端 | mobile |
| Web 前端 | web |
| 服务端 | server |

### ✅ 推荐

```
feat(登录认证): 增加手机号验证码登录
fix(支付模块): 修复微信支付重复回调问题
refactor(订单模块): 重构订单状态流转逻辑
```

### ❌ 禁止

```
fix(代码)
fix(更新)
fix(测试)
fix(其他)
```

scope 必须具备明确业务含义。

---

## 5. 简要描述（summary）

要求：
- 使用中文
- 简洁明确
- 不超过 50 字
- 使用动词开头
- 一句话说明本次提交

### ✅ 推荐

```
修复订单状态同步异常
增加手机号验证码登录
重构支付回调逻辑
```

### ❌ 禁止

```
修改代码
优化一下
update
fix bug
再次修改
临时提交
```

---

## 6. 详细描述（body）

用于说明：
- 改了什么
- 如何实现
- 影响哪些逻辑

### 格式要求

```
- 内容1
- 内容2
- 内容3
```

至少填写 1 条。

### ✅ 推荐

```
- 增加 JWT 过期时间校验
- 修复 refresh token 未失效的问题
- 统一认证失败返回状态码
```

### ❌ 禁止

```
- 修改代码
- 调整逻辑
- 优化内容
```

必须描述具体改动。

---

## 7. 关联任务（Refs）

用于关联：
- Jira
- 禅道
- 飞书任务
- Bug 编号
- 需求编号

### 有对应任务时填写

```
Refs: BUG-1024
Refs: AUTH-221
Refs: TASK-889
```

### 无任务编号时

可省略 Refs

---

## 8. 标准示例

### feat 示例

```
feat(用户模块): 增加手机号验证码登录功能

- 新增短信验证码登录接口
- 增加验证码发送频率限制
- 新增 JWT 登录态生成逻辑

Refs: USER-1021
```

### fix 示例

```
fix(支付模块): 修复微信支付回调重复入账问题

- 增加支付回调幂等校验
- 使用 transaction_id 防止重复处理
- 修复并发情况下重复更新订单状态问题

Refs: BUG-1024
```

### refactor 示例

```
refactor(订单模块): 重构订单状态流转逻辑

- 拆分订单状态处理器
- 使用状态模式替代 if/else
- 解耦退款与发货逻辑

Refs: TECH-331
```

---

## 9. 禁止提交内容

以下 Commit Message 禁止提交：

```
update
fix
test
bug
修改
优化
临时提交
wip
111
最终版
再次修改
提交代码
```

禁止无意义提交。

---

## 10. Commit 拆分原则

推荐：一个 Commit 只做一件事情。

### ✅ 正确示例

```
feat(用户模块): 增加手机号登录
fix(登录认证): 修复 token 校验异常
```

### ❌ 错误示例

```
fix: 修改登录 + 修复支付 + 更新后台页面
```

禁止一个 Commit 包含多个无关修改。

---

## 11. 提交频率建议

### 推荐

- 完成一个完整功能点后提交
- 完成一个明确 Bug 修复后提交
- 完成一次独立重构后提交

### ❌ 禁止

- 每改一行提交一次
- 长时间不提交，最后一次性提交大量代码

---

## 12. 最终目标

只看 `git log` 即可快速理解项目演进历史。

```
feat(登录认证): 增加手机号验证码登录
fix(支付模块): 修复支付回调重复入账
refactor(订单模块): 重构订单状态机逻辑
```

无需查看代码即可理解主要改动内容。

---

## 13. 分支命名规范（基于 Commit 规范推导）

### 标准格式

```
<prefix>/<scope-en>-<short-description>
```

### 分支前缀

| 前缀 | 用途 |
|------|------|
| `feature/` | 新功能 (feat) |
| `fix/` | Bug 修复 (fix) |
| `refactor/` | 代码重构 (refactor) |
| `perf/` | 性能优化 (perf) |
| `test/` | 测试 (test) |
| `docs/` | 文档 (docs) |
| `style/` | 格式 (style) |
| `chore/` | 杂项 (chore) |

### 示例

```
feature/login-phone-verify
fix/payment-duplicate-notify
refactor/order-state-flow
perf/api-query-optimize
test/user-module-coverage
docs/api-document-update
chore/deps-upgrade
```

### 要求

- scope 和描述使用英文小写 + 短横线
- 简洁、可读、表意明确
- 禁止：`fix-bug`、`test`、`temp`、`111`

---

## 14. 规范生效

本规范自发布日起立即生效。所有开发人员必须遵守。
