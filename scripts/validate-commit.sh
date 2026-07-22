#!/usr/bin/env bash
# Git Commit Message Validator
# 用于 git commit-msg hook，自动校验提交信息是否符合团队规范
#
# 安装方式：
#   cp validate-commit.sh .git/hooks/commit-msg
#   chmod +x .git/hooks/commit-msg
#
# 或使用 setup-pre-commit skill 统一管理

set -euo pipefail

COMMIT_MSG_FILE="$1"
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# ----- 1. 检查是否为空 -----
if [[ -z "$COMMIT_MSG" ]]; then
    echo -e "${RED}❌ 错误：提交信息不能为空${NC}"
    exit 1
fi

# ----- 2. 检查第一行格式：<type>(<scope>): <summary> -----
FIRST_LINE=$(echo "$COMMIT_MSG" | head -1)

# 允许的 type
VALID_TYPES="feat|fix|refactor|perf|test|docs|style|chore"

# 检查格式
if ! echo "$FIRST_LINE" | grep -qE "^($VALID_TYPES)\(.+\): .+"; then
    echo -e "${RED}❌ 错误：提交标题格式不正确${NC}"
    echo -e "   期望格式：${GREEN}<type>(<scope>): <summary>${NC}"
    echo -e "   type 必须是: ${VALID_TYPES}"
    echo -e "   示例：${GREEN}feat(用户模块): 增加手机号验证码登录${NC}"
    ERRORS=$((ERRORS + 1))
fi

# ----- 3. 检查 summary 长度 -----
SUMMARY=$(echo "$FIRST_LINE" | sed 's/^[^(]*([^)]*): //')
SUMMARY_LEN=${#SUMMARY}
if [[ $SUMMARY_LEN -gt 50 ]]; then
    echo -e "${RED}❌ 错误：summary 超过 50 字（当前 ${SUMMARY_LEN} 字）${NC}"
    echo -e "   summary: ${SUMMARY}"
    ERRORS=$((ERRORS + 1))
fi

# ----- 4. 检查禁止词汇 -----
BANNED_WORDS=(
    "^update$"
    "^fix$"
    "^test$"
    "^bug$"
    "^修改$"
    "^优化$"
    "^优化一下$"
    "^临时提交$"
    "^wip$"
    "^111$"
    "^最终版$"
    "^再次修改$"
    "^提交代码$"
    "^修改代码$"
    "^调整逻辑$"
    "^优化内容$"
    "^fix bug$"
)

for word in "${BANNED_WORDS[@]}"; do
    if echo "$COMMIT_MSG" | grep -qiE "$word"; then
        echo -e "${RED}❌ 错误：提交信息中包含禁止词汇: ${word}${NC}"
        ERRORS=$((ERRORS + 1))
    fi
done

# ----- 5. 检查 body 是否有意义（如果有第二行） -----
BODY_LINE_COUNT=$(echo "$COMMIT_MSG" | tail -n +2 | grep -cE "^- " || true)
if [[ $BODY_LINE_COUNT -lt 1 ]]; then
    echo -e "${YELLOW}⚠️  警告：建议添加详细描述（body），至少 1 条 - 开头${NC}"
    echo -e "   示例：${GREEN}- 增加支付回调幂等校验${NC}"
    WARNINGS=$((WARNINGS + 1))
fi

# ----- 6. 检查 body 中是否有无意义描述 -----
BANNED_BODY=(
    "^- 修改代码"
    "^- 优化"
    "^- 调整"
    "^- fix"
    "^- update"
)
for pattern in "${BANNED_BODY[@]}"; do
    if echo "$COMMIT_MSG" | grep -qiE "$pattern"; then
        echo -e "${YELLOW}⚠️  警告：body 中可能包含无意义描述: ${pattern}${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
done

# ----- 7. 输出结果 -----
echo ""
if [[ $ERRORS -gt 0 ]]; then
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}  ❌ 提交被拒绝：${ERRORS} 个错误，${WARNINGS} 个警告${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "完整规范见: /Users/apple/.codex/skills/git-commit/REFERENCE.md"
    exit 1
elif [[ $WARNINGS -gt 0 ]]; then
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}  ⚠️  提交通过但有 ${WARNINGS} 个警告${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
else
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  ✅ 提交信息格式正确！${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
fi

exit 0
