#!/bin/bash

# ===============================================
# 開発環境 セットアップテスト
# ===============================================

set -e

# カラー出力
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🧪 開発環境 セットアップテスト${NC}"
echo "=============================================="

# テスト結果のカウンター
TESTS_PASSED=0
TESTS_FAILED=0

# テスト関数
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_result="$3"
    
    echo -e "${BLUE}🔍 テスト: $test_name${NC}"
    
    if eval "$test_command" >/dev/null 2>&1; then
        if [ "$expected_result" = "pass" ]; then
            echo -e "${GREEN}✅ 成功${NC}"
            ((TESTS_PASSED++))
        else
            echo -e "${RED}❌ 失敗（予期しない成功）${NC}"
            ((TESTS_FAILED++))
        fi
    else
        if [ "$expected_result" = "fail" ]; then
            echo -e "${GREEN}✅ 成功（期待通りの失敗）${NC}"
            ((TESTS_PASSED++))
        else
            echo -e "${RED}❌ 失敗${NC}"
            ((TESTS_FAILED++))
        fi
    fi
}

# 必要なツールの存在チェック
echo -e "${BLUE}📋 必要なツールの確認${NC}"

run_test "Git インストール確認" "command -v git" "pass"
run_test "WezTerm インストール確認" "command -v wezterm" "pass"

# 設定ファイルの存在チェック
echo -e "${BLUE}📁 設定ファイルの確認${NC}"

run_test "WezTerm設定ファイル存在確認" "test -f ~/.wezterm.lua" "pass"


# 結果サマリー
echo ""
echo -e "${BLUE}📊 テスト結果サマリー${NC}"
echo "=============================="
echo -e "${GREEN}✅ 成功: $TESTS_PASSED${NC}"
echo -e "${RED}❌ 失敗: $TESTS_FAILED${NC}"

TOTAL_TESTS=$((TESTS_PASSED + TESTS_FAILED))
if [ $TOTAL_TESTS -gt 0 ]; then
    SUCCESS_RATE=$((TESTS_PASSED * 100 / TOTAL_TESTS))
    echo -e "${BLUE}📈 成功率: $SUCCESS_RATE%${NC}"
fi

echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 すべてのテストが成功しました！${NC}"
    echo -e "${GREEN}開発環境は正常に動作しています${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  一部のテストが失敗しました${NC}"
    exit 1
fi