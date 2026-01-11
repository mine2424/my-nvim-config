#!/usr/bin/env bash
# sync.sh - 設定ファイルの双方向同期
# dotfilesとローカルPC間で設定を同期

set -euo pipefail

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ユーティリティ関数の読み込み
# shellcheck source=./utils/common.sh
source "$SCRIPT_DIR/utils/common.sh"
# shellcheck source=./utils/os-detect.sh
source "$SCRIPT_DIR/utils/os-detect.sh"

# グローバル変数
DIRECTION="push"  # push: dotfiles -> local, pull: local -> dotfiles
DRY_RUN=false
FORCE=false
COMPONENT="all"

#######################################
# 使用方法を表示
#######################################
show_usage() {
    cat <<EOF
使用方法: $(basename "$0") [方向] [オプション] [コンポーネント]

dotfilesとローカルPC間で設定を同期します。

方向:
  push               dotfiles -> ローカルPC（デフォルト）
  pull               ローカルPC -> dotfiles

コンポーネント:
  --all              すべての設定を同期（デフォルト）
  --nvim             Neovim設定のみ
  --shell            シェル設定のみ
  --terminal         ターミナル設定のみ
  --cli              CLIツール設定のみ

オプション:
  --dry-run          実際には同期せず、何が行われるか表示
  --force            確認なしで実行
  -h, --help         このヘルプを表示

例:
  # dotfilesからローカルPCに反映（デフォルト）
  $(basename "$0") push

  # ローカルPCからdotfilesに取り込み
  $(basename "$0") pull

  # WezTerm設定のみ同期
  $(basename "$0") push --terminal

  # ドライランモード
  $(basename "$0") push --dry-run

EOF
}

#######################################
# 引数を解析
#######################################
parse_arguments() {
    # 最初の引数が方向指定かチェック
    if [[ $# -gt 0 ]] && [[ "$1" == "push" || "$1" == "pull" ]]; then
        DIRECTION="$1"
        shift
    fi
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            push|pull)
                DIRECTION="$1"
                shift
                ;;
            --all)
                COMPONENT="all"
                shift
                ;;
            --nvim)
                COMPONENT="nvim"
                shift
                ;;
            --shell)
                COMPONENT="shell"
                shift
                ;;
            --terminal)
                COMPONENT="terminal"
                shift
                ;;
            --cli)
                COMPONENT="cli"
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --force)
                FORCE=true
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                log_error "不明なオプション: $1"
                show_usage
                exit 1
                ;;
        esac
    done
}

#######################################
# ファイルを同期
# Arguments:
#   $1 - ソースパス
#   $2 - ターゲットパス
#   $3 - 説明
#######################################
sync_file() {
    local source="$1"
    local target="$2"
    local description="$3"
    
    # パスの展開
    source="${source/#\~/$HOME}"
    target="${target/#\~/$HOME}"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        if [[ -e "$source" ]]; then
            log_info "[DRY RUN] 同期予定: $description"
            log_info "           $source -> $target"
        else
            log_warn "[DRY RUN] スキップ（存在しません）: $source"
        fi
        return 0
    fi
    
    # ソースが存在しない場合はスキップ
    if [[ ! -e "$source" ]] && [[ ! -L "$source" ]]; then
        log_debug "スキップ（存在しません）: $source"
        return 0
    fi
    
    log_info "同期: $description"
    log_debug "$source -> $target"
    
    # ターゲットディレクトリの作成
    local target_dir
    target_dir="$(dirname "$target")"
    safe_mkdir "$target_dir" || return 1
    
    # ファイル/ディレクトリのコピー
    # 既に存在する場合は、同一かどうかをチェック
    if [[ -e "$target" ]] && [[ -f "$source" ]] && [[ -f "$target" ]]; then
        if cmp -s "$source" "$target" 2>/dev/null; then
            log_debug "ファイルは既に同一です: $target"
            log_success "同期完了: ${description}（変更なし）"
            return 0
        fi
    fi
    
    # ファイル/ディレクトリのコピー
    if cp -r "$source" "$target" 2>/dev/null; then
        log_success "同期完了: ${description}"
        return 0
    else
        # cpが失敗した場合でも、ターゲットが存在し、同一の場合は成功として扱う
        if [[ -e "$target" ]] && [[ -f "$source" ]] && [[ -f "$target" ]]; then
            if cmp -s "$source" "$target" 2>/dev/null; then
                log_debug "ファイルは既に同一です: $target"
                log_success "同期完了: ${description}（変更なし）"
                return 0
            fi
        fi
        log_error "同期に失敗しました: ${description}"
        return 1
    fi
}

#######################################
# Neovim設定を同期
#######################################
sync_nvim() {
    log_section "Neovim設定の同期"
    
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"
    local nvim_config="$(get_config_dir nvim)"
    
    if [[ "$DIRECTION" == "push" ]]; then
        sync_file "$dotfiles_root/nvim" "$nvim_config" "Neovim設定"
    else
        sync_file "$nvim_config" "$dotfiles_root/nvim" "Neovim設定"
    fi
}

#######################################
# シェル設定を同期
#######################################
sync_shell() {
    log_section "シェル設定の同期"
    
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"
    
    if [[ "$DIRECTION" == "push" ]]; then
        # dotfiles -> local
        sync_file "$dotfiles_root/zsh/zshrc" "$HOME/.zshrc" "Zsh設定"
        sync_file "$dotfiles_root/zsh/zshenv" "$HOME/.zshenv" "Zsh環境変数"
        sync_file "$dotfiles_root/zsh/zprofile" "$HOME/.zprofile" "Zshプロファイル"
        sync_file "$dotfiles_root/zsh/sheldon" "$(get_config_dir sheldon)" "Sheldon設定"
        sync_file "$dotfiles_root/starship/.config/starship.toml" "$(get_config_dir)/starship.toml" "Starship設定"
        sync_file "$dotfiles_root/npm/npmrc" "$HOME/.npmrc" "npm設定"
        sync_file "$dotfiles_root/npm/.config/npm/npmrc" "$(get_config_dir)/npm/npmrc" "npmグローバル設定"
    else
        # local -> dotfiles
        sync_file "$HOME/.zshrc" "$dotfiles_root/zsh/zshrc" "Zsh設定"
        sync_file "$HOME/.zshenv" "$dotfiles_root/zsh/zshenv" "Zsh環境変数"
        sync_file "$HOME/.zprofile" "$dotfiles_root/zsh/zprofile" "Zshプロファイル"
        sync_file "$(get_config_dir sheldon)" "$dotfiles_root/zsh/sheldon" "Sheldon設定"
        sync_file "$(get_config_dir)/starship.toml" "$dotfiles_root/starship/.config/starship.toml" "Starship設定"
        sync_file "$HOME/.npmrc" "$dotfiles_root/npm/npmrc" "npm設定"
        sync_file "$(get_config_dir)/npm/npmrc" "$dotfiles_root/npm/.config/npm/npmrc" "npmグローバル設定"
    fi
}

#######################################
# ターミナル設定を同期
#######################################
sync_terminal() {
    log_section "ターミナル設定の同期"
    
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"
    local wezterm_config="$(get_config_dir wezterm)/wezterm.lua"
    
    if [[ "$DIRECTION" == "push" ]]; then
        # dotfiles -> local
        sync_file "$dotfiles_root/wezterm/.config/wezterm/wezterm.lua" "$wezterm_config" "WezTerm設定"
    else
        # local -> dotfiles
        sync_file "$wezterm_config" "$dotfiles_root/wezterm/.config/wezterm/wezterm.lua" "WezTerm設定"
    fi
}

#######################################
# CLIツール設定を同期
#######################################
sync_cli_tools() {
    log_section "CLIツール設定の同期"
    
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"
    
    if [[ "$DIRECTION" == "push" ]]; then
        # dotfiles -> local
        if [[ -f "$dotfiles_root/cli-tools/gitconfig" ]]; then
            sync_file "$dotfiles_root/cli-tools/gitconfig" "$HOME/.gitconfig" "Git設定"
        fi
        if [[ -f "$dotfiles_root/cli-tools/tmux.conf" ]]; then
            sync_file "$dotfiles_root/cli-tools/tmux.conf" "$HOME/.tmux.conf" "tmux設定"
        fi
    else
        # local -> dotfiles
        sync_file "$HOME/.gitconfig" "$dotfiles_root/cli-tools/gitconfig" "Git設定"
        sync_file "$HOME/.tmux.conf" "$dotfiles_root/cli-tools/tmux.conf" "tmux設定"
    fi
}

#######################################
# すべての設定を同期
#######################################
sync_all() {
    sync_nvim
    sync_shell
    sync_terminal
    sync_cli_tools
}

#######################################
# 同期前の確認
#######################################
confirm_sync() {
    if [[ "$FORCE" == "true" ]]; then
        return 0
    fi
    
    if [[ "$DRY_RUN" == "true" ]]; then
        return 0
    fi
    
    echo ""
    log_warn "以下の設定が同期されます:"
    
    if [[ "$DIRECTION" == "push" ]]; then
        log_info "方向: dotfiles -> ローカルPC"
    else
        log_info "方向: ローカルPC -> dotfiles"
    fi
    
    case "$COMPONENT" in
        all)
            echo "  - Neovim設定"
            echo "  - シェル設定（Zsh + Starship）"
            echo "  - ターミナル設定（WezTerm）"
            echo "  - CLIツール設定（Git, tmux等）"
            ;;
        nvim)
            echo "  - Neovim設定"
            ;;
        shell)
            echo "  - シェル設定（Zsh + Starship）"
            ;;
        terminal)
            echo "  - ターミナル設定（WezTerm）"
            ;;
        cli)
            echo "  - CLIツール設定（Git, tmux等）"
            ;;
    esac
    
    echo ""
    
    if ! confirm "続行しますか？" "n"; then
        log_info "キャンセルしました"
        exit 0
    fi
}

#######################################
# サマリーを表示
#######################################
show_summary() {
    log_section "同期完了"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "ドライランモードで実行しました"
        log_info "実際に同期するには --dry-run オプションを外してください"
    else
        log_success "同期が完了しました"
        
        if [[ "$DIRECTION" == "push" ]]; then
            log_info "dotfilesの設定がローカルPCに反映されました"
            log_info "シェルを再起動してください: exec \$SHELL"
        else
            log_info "ローカルPCの設定がdotfilesに取り込まれました"
            log_info "変更をコミットしてください: git add . && git commit"
        fi
    fi
}

#######################################
# メイン処理
#######################################
main() {
    # 引数の解析
    parse_arguments "$@"
    
    # ヘッダー表示
    log_section "Dotfiles 同期スクリプト"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "モード: ドライラン（実際には同期しません）"
    fi
    
    log_info "方向: $DIRECTION"
    log_info "コンポーネント: $COMPONENT"
    
    # システム情報の表示
    log_debug "OS: $(detect_os)"
    
    # 確認
    confirm_sync
    
    # 同期の実行
    case "$COMPONENT" in
        all)
            sync_all
            ;;
        nvim)
            sync_nvim
            ;;
        shell)
            sync_shell
            ;;
        terminal)
            sync_terminal
            ;;
        cli)
            sync_cli_tools
            ;;
        *)
            log_error "不明なコンポーネント: $COMPONENT"
            exit 1
            ;;
    esac
    
    # サマリー表示
    show_summary
}

# スクリプトの実行
main "$@"
