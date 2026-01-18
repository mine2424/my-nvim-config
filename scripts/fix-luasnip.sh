#!/usr/bin/env bash
# fix-luasnip.sh - LuaSnipプラグインのローカル変更をリセット

set -euo pipefail

LUASNIP_DIR="$HOME/.local/share/nvim/lazy/LuaSnip"

if [[ ! -d "$LUASNIP_DIR" ]]; then
    echo "LuaSnipディレクトリが見つかりません: $LUASNIP_DIR"
    exit 1
fi

echo "LuaSnipプラグインのローカル変更をリセット中..."

cd "$LUASNIP_DIR"

# Gitリポジトリかどうか確認
if [[ ! -d ".git" ]]; then
    echo "警告: Gitリポジトリではありません。プラグインを削除して再インストールしてください。"
    echo "削除しますか？ (y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        cd ..
        rm -rf LuaSnip
        echo "LuaSnipプラグインを削除しました。Neovimを起動して再インストールしてください。"
    fi
    exit 0
fi

# ローカル変更をリセット
if git reset --hard HEAD 2>/dev/null; then
    echo "✓ Gitリセット成功"
else
    echo "✗ Gitリセット失敗"
    exit 1
fi

# 未追跡ファイルを削除
if git clean -fd 2>/dev/null; then
    echo "✓ 未追跡ファイルの削除成功"
else
    echo "✗ 未追跡ファイルの削除失敗"
    exit 1
fi

# サブモジュールのリセット
if [[ -f ".gitmodules" ]]; then
    echo "サブモジュールをリセット中..."
    git submodule update --init --recursive --force 2>/dev/null || true
fi

echo ""
echo "✓ LuaSnipプラグインのリセットが完了しました"
echo "Neovimで :Lazy sync を実行して更新してください"
