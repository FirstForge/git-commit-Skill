---
name: git-commit
description: "Enforce the company Git workflow in every project. Use whenever the user mentions creating a branch, switching to a new branch, committing code, writing a commit message, staging changes, or following Git conventions. Requires asking the user to confirm generated branch names and commit messages. Commit format is type(scope): summary with Chinese scope, summary, and body. Triggers include 新建分支, 创建分支, 切分支, branch, commit, 提交, 提交代码, git规范, commit规范."
---

# 公司 Git 规范助手

目标很简单：分支名和 commit 记录要让别人只看 `git log` 就知道发生了什么。完整规范见 [REFERENCE.md](REFERENCE.md)。

## 硬规则

- 用户说要新建分支时，必须先根据用途生成一个分支名候选，然后询问用户是否同意。
- 未经用户确认，不要执行 `git checkout -b`、`git switch -c` 或其他创建分支命令。
- 用户说要 commit 时，必须先查看改动，再生成符合规范的 commit message，并让用户确认。
- commit 前必须检查本次分支改动是否已经更新给 leader 审查用的 md 文档。md 文档本质是本次分支改动内容、问题背景、设计思路和维护口径。
- 如果本次改动涉及业务逻辑、页面交互、架构设计、状态机、资源加载、接口路径、构建规则或线上排查口径，原则上都需要更新审核 md。
- 审核 md 优先内化到项目已有文档里，不能每做一件事就随便新增一个孤立 md，避免 docs 膨胀。
- 如果没有找到合适的已有 md，必须先提示用户并询问写到哪里，不能擅自新增文档后直接 commit。
- 如果应该写审核 md 但暂存区没有相关 docs 改动，必须停下来提醒用户，由用户决定是否现在补 md；未经用户明确确认，不能继续 commit。
- 未经用户确认，不要执行 `git commit`。
- commit body 至少 1 条，不能只写“修改代码”“优化内容”“调整逻辑”这类空话。
- 如果一次改动明显包含多件无关的事，提醒用户拆成多个 commit。

## 新建分支流程

用户表达“我接下来要新建分支，用于开发/修复/重构某事”时：

1. 判断用途对应的类型。
2. 判断影响模块。如果信息不够，直接问用户模块是什么。
3. 生成 1 个推荐分支名，必要时给 1 个备选。
4. 用白话说明为什么这样命名。
5. 问用户是否确认使用这个分支名。
6. 用户确认后再创建分支。

### 分支类型映射

| 用途 | 分支前缀 | commit type |
| --- | --- | --- |
| 新功能 | `feature/` | `feat` |
| 修复问题 | `fix/` | `fix` |
| 代码重构 | `refactor/` | `refactor` |
| 性能优化 | `perf/` | `perf` |
| 测试相关 | `test/` | `test` |
| 文档修改 | `docs/` | `docs` |
| 格式调整 | `style/` | `style` |
| 构建、配置、依赖 | `chore/` | `chore` |

### 分支名格式

```text
<prefix>/<scope-en>-<short-description>
```

要求：

- 使用英文小写、数字和短横线。
- 不使用中文、空格、下划线。
- 简短但要能看懂业务含义。
- 禁止 `fix-bug`、`test`、`temp`、`wip`、`111` 这类无意义名字。

示例：

```text
feature/login-phone-verification
fix/payment-duplicate-callback
refactor/order-state-flow
```

推荐回复格式：

```text
我建议分支名用：
feature/login-phone-verification

原因：这是登录认证的新功能，内容是手机号验证码登录。
你确认用这个名字吗？确认后我再创建分支。
```

## Commit 流程

用户要求提交代码、生成 commit 描述、commit message 或执行 commit 时：

1. 先执行 `git status --short` 看哪些文件变了。
2. 再执行 `git diff --stat` 看改动范围。
3. 检查是否已经有审核 md 文档改动：
   - 先看 staged/unstaged 是否包含 `docs/**/*.md` 或项目约定的文档文件。
   - 如果有，判断它是否在说明本次分支的改动内容、设计思路、维护口径，而不是无关文档。
   - 如果没有，先看本次改动性质是否需要 md；需要时停下来提示用户确认是否补文档，不能直接 commit。
4. 需要写 md 时，先阅读 `docs/` 下已有文档结构，优先更新已有总文档、模块文档或专项方案文档。
5. 如需判断具体代码内容，读取 `git diff --cached` 或相关文件差异。
6. 判断 type、scope、summary、body。
7. 如有任务编号，加入 `Refs: <issue-id>`；没有就省略。
8. 展示完整 commit message 给用户确认。
9. 用户确认后再执行 commit。

### 审核 md 文档要求

审核 md 是给 leader 看本次分支为什么这样改，不是流水账，也不是把 commit message 复制一遍。

必须覆盖：

- 问题背景：用户看到什么问题，为什么现有逻辑不够。
- 改动内容：改了哪些路径、状态机、资源生命周期、接口调用或缓存策略。
- 设计思路：为什么这样改，关键取舍是什么。
- 维护口径：以后遇到同类问题应该看哪里、不能再怎么写。
- 影响范围：涉及哪些页面、模块、入口或回归场景。

写法要求：

- 优先更新已有 md，例如模块总文档、功能说明、专项优化方案。
- 不要为每个小改动新增单独 md；只有现有文档完全没有承载位置时才考虑新增。
- 新增 md 前必须先问用户确认文档位置和文件名。
- 文档要写成当前最新口径，不能保留与代码相冲突的旧描述。
- 如果代码改了但 md 没有更新，commit 前必须明确提示用户：“当前缺少审核 md，是否需要我先补？”

### Commit 标准格式

```text
<type>(<scope>): <summary>

- <具体改动 1>
- <具体改动 2>

Refs: <issue-id>
```

`Refs` 可选；没有任务编号时不要硬编。

### type

只能使用：

```text
feat fix refactor perf test docs style chore
```

### scope

scope 推荐使用中文，并且必须有明确业务含义。

常用 scope：

```text
登录认证 用户模块 支付模块 订单模块 管理后台 接口服务 网关服务 缓存模块 消息通知 文件上传 配置管理 数据库 定时任务 日志模块 短信模块 邮件模块 搜索模块 报表模块 AI 功能 页面 UI 移动端 Web 前端 服务端
```

禁止：

```text
代码 更新 测试 其他
```

### summary

要求：

- 中文。
- 不超过 50 字。
- 动词开头。
- 一句话讲清楚本次提交做了什么。

推荐：

```text
修复订单状态同步异常
增加手机号验证码登录
重构支付回调逻辑
```

禁止：

```text
修改代码
优化一下
update
fix bug
再次修改
临时提交
```

### body

要求：

- 至少 1 条。
- 每条用 `- ` 开头。
- 说具体改了什么、怎么改、影响什么逻辑。

推荐：

```text
- 增加 JWT 过期时间校验
- 修复 refresh token 未失效的问题
- 统一认证失败返回状态码
```

禁止：

```text
- 修改代码
- 调整逻辑
- 优化内容
```

## 提交前检查

在真正 commit 前检查：

- 是否有 staged 文件。没有 staged 文件时，不要 commit，先告诉用户需要 stage 哪些文件。
- 是否还有未 staged 改动。若有，说明哪些会进入 commit，哪些不会进入。
- commit 第一行是否符合 `<type>(<scope>): <summary>`。
- scope 是否有业务含义。
- summary 是否中文、具体、不超过 50 字。
- body 是否至少 1 条。
- 是否出现禁止词。
- 是否把多个无关改动塞进一个 commit。

可用脚本：

```bash
/Users/apple/.codex/skills/git-commit/scripts/validate-commit.sh <commit-message-file>
```

## 推荐 commit 命令方式

多行 commit message 不要塞进一堆 `-m` 里。优先写入临时文件后执行：

```bash
git commit -F /tmp/commit-message.txt
```

执行前必须展示 commit message 给用户确认。
