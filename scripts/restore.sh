#!/usr/bin/env bash
# restore.sh - バックアップから設定を復元
# バックアップから設定ファイルを復元

set -euo pipefail

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ユーティリティ関数の読み込み
# shellcheck source=./utils/common.sh
source "$SCRIPT_DIR/utils/common.sh"
# shellcheck source=./utils/os-detect.sh
source "$SCRIPT_DIR/utils/os-detect.sh"
# shellcheck source=./utils/logger.sh
source "$SCRIPT_DIR/utils/logger.sh"
# shellcheck source=./utils/backup.sh
source "$SCRIPT_DIR/utils/backup.sh"

# グローバル変数
BACKUP_NAME=""
USE_LATEST=false
LIST_ONLY=false
DRY_RUN=false
COMPONENT="all"
FORCE=false

#######################################
# 使用方法を表示
#######################################
show_usage() {
    cat <<EOF
使用方法: $(basename "$0") [オプション]

バックアップから設定ファイルを復元します。

オプション:
  --list             バックアップ一覧を表示
  --latest           最新のバックアップから復元
  --backup NAME      指定したバックアップから復元
  --all              すべての設定を復元（デフォルト）
  --nvim             Neovim設定のみ復元
  --shell            シェル設定のみ復元
  --terminal         ターミナル設定のみ復元
  --cli              CLIツール設定のみ復元
  --dry-run          実際には復元せず、何が復元されるか表示
  --force            確認なしで実行
  -h, --help         このヘルプを表示

例:
  # バックアップ一覧を表示
  $(basename "$0") --list

  # 最新のバックアップから復元
  $(basename "$0") --latest

  # 特定のバックアップから復元
  $(basename "$0") --backup 20260111_143022

  # Neovim設定のみ復元
  $(basename "$0") --latest --nvim

  # ドライランモード
  $(basename "$0") --latest --dry-run

EOF
}

#######################################
# 引数を解析
#######################################
parse_arguments() {
    if [[ $# -eq 0 ]]; then
        show_usage
        exit 0
    fi
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --list)
                LIST_ONLY=true
                shift
                ;;
            --latest)
                USE_LATEST=true
                shift
                ;;
            --backup)
                if [[ -z "${2:-}" ]]; then
                    log_error "--backup オプションにはバックアップ名が必要です"
                    exit 1
                fi
                BACKUP_NAME="$2"
                shift 2
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
# バックアップを選択
# Returns:
#   選択されたバックアップのパス
#######################################
select_backup() {
    local backup_path=""
    
    if [[ "$USE_LATEST" == "true" ]]; then
        backup_path="$(get_latest_backup)"
        if [[ -z "$backup_path" ]]; then
            log_error "バックアップが見つかりません"
            exit 1
        fi
        log_info "最新のバックアップを使用: $(basename "$backup_path")"
    elif [[ -n "$BACKUP_NAME" ]]; then
        backup_path="$BACKUP_DIR/$BACKUP_NAME"
        if [[ ! -d "$backup_path" ]]; then
            log_error "バックアップが見つかりません: $BACKUP_NAME"
            exit 1
        fi
        log_info "バックアップを使用: $BACKUP_NAME"
    else
        log_error "--latest または --backup オプションを指定してください"
        exit 1
    fi
    
    echo "$backup_path"
}

#######################################
# アイテムを復元
# Arguments:
#   $1 - バックアップ内のパス
#   $2 - 復元先パス
#   $3 - 説明
# Returns:
#   0 - 成功（または存在しない）
#   1 - 失敗
#######################################
restore_item() {
    local backup_item="$1"
    local target="$2"
    local description="$3"
    
    # 復元先パスの展開
    target="${target/#\~/$HOME}"
    
    # バックアップアイテムの存在確認
    if [[ ! -e "$backup_item" ]] && [[ ! -L "$backup_item" ]]; then
        log_debug "スキップ（バックアップに存在しません）: $description"
        return 0
    fi
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] 復元予定: $description"
        log_info "           復元先: $target"
        return 0
    fi
    
    log_info "復元: $description"
    log_debug "復元先: $target"
    
    # 既存ファイルの確認
    if [[ -e "$target" ]] || [[ -L "$target" ]]; then
        local backup_existing="${target}.before_restore.$(get_timestamp)"
        log_warn "既存ファイルをバックアップ: $backup_existing"
        mv "$target" "$backup_existing"
    fi
    
    # 親ディレクトリの作成
    local target_dir
    target_dir="$(dirname "$target")"
    safe_mkdir "$target_dir" || return 1
    
    # シンボリックリンクの処理
    if [[ -f "${backup_item}.symlink" ]]; then
        local link_target
        link_target="$(cat "${backup_item}.symlink")"
        log_debug "シンボリックリンクとして復元: $target -> $link_target"
        ln -s "$link_target" "$target"
        return 0
    fi
    
    # ファイル/ディレクトリのコピー
    if cp -r "$backup_item" "$target" 2>/dev/null; then
        return 0
    else
        log_error "復元に失敗しました: $target"
        return 1
    fi
}

#######################################
# Neovim設定を復元
# Arguments:
#   $1 - バックアップディレクトリパス
#######################################
restore_nvim() {
    log_section "Neovim設定の復元"
    
    local backup_path="$1"
    local items=(
        "nvim_config:$(get_config_dir nvim):Neovim設定ディレクトリ"
        "nvim_data:$(get_data_dir nvim):Neovimデータディレクトリ"
        "nvim_cache:$(get_cache_dir nvim):Neovimキャッシュディレクトリ"
    )
    
    local restored_count=0
    for item in "${items[@]}"; do
        IFS=':' read -r backup_name target description <<< "$item"
        local backup_item="$backup_path/$backup_name"
        if restore_item "$backup_item" "$target" "$description"; then
            ((restored_count++))
        fi
    done
    
    if [[ "$DRY_RUN" == "false" ]]; then
        log_success "Neovim設定を復元しました（${restored_count}アイテム）"
    fi
}

#######################################
# シェル設定を復元
# Arguments:
#   $1 - バックアップディレクトリパス
#######################################
restore_shell() {
    log_section "シェル設定の復元"
    
    local backup_path="$1"
    local items=(
        "zshrc:$HOME/.zshrc:Zsh設定ファイル"
        "zshenv:$HOME/.zshenv:Zsh環境変数ファイル"
        "zprofile:$HOME/.zprofile:Zshプロファイル"
        "sheldon:$(get_config_dir sheldon):Sheldon設定"
        "bashrc:$HOME/.bashrc:Bash設定ファイル"
        "bash_profile:$HOME/.bash_profile:Bashプロファイル"
    )
    
    local restored_count=0
    for item in "${items[@]}"; do
        IFS=':' read -r backup_name target description <<< "$item"
        local backup_item="$backup_path/$backup_name"
        if restore_item "$backup_item" "$target" "$description"; then
            ((restored_count++))
        fi
    done
    
    if [[ "$DRY_RUN" == "false" ]]; then
        log_success "シェル設定を復元しました（${restored_count}アイテム）"
    fi
}

#######################################
# ターミナル設定を復元
# Arguments:
#   $1 - バックアップディレクトリパス
#######################################
restore_terminal() {
    log_section "ターミナル設定の復元"
    
    local backup_path="$1"
    local items=(
        "wezterm:$(get_config_dir wezterm):WezTerm設定"
        "starship:$(get_config_dir starship.toml):Starship設定"
        "alacritty:$(get_config_dir alacritty):Alacritty設定"
    )
    
    local restored_count=0
    for item in "${items[@]}"; do
        IFS=':' read -r backup_name target description <<< "$item"
        local backup_item="$backup_path/$backup_name"
        if restore_item "$backup_item" "$target" "$description"; then
            ((restored_count++))
        fi
    done
    
    if [[ "$DRY_RUN" == "false" ]]; then
        log_success "ターミナル設定を復元しました（${restored_count}アイテム）"
    fi
}

#######################################
# CLIツール設定を復元
# Arguments:
#   $1 - バックアップディレクトリパス
#######################################
restore_cli_tools() {
    log_section "CLIツール設定の復元"
    
    local backup_path="$1"
    local items=(
        "gitconfig:$HOME/.gitconfig:Git設定"
        "tmux:$HOME/.tmux.conf:tmux設定"
        "vim:$HOME/.vimrc:Vim設定"
    )
    
    local restored_count=0
    for item in "${items[@]}"; do
        IFS=':' read -r backup_name target description <<< "$item"
        local backup_item="$backup_path/$backup_name"
        if restore_item "$backup_item" "$target" "$description"; then
            ((restored_count++))
        fi
    done
    
    if [[ "$DRY_RUN" == "false" ]]; then
        log_success "CLIツール設定を復元しました（${restored_count}アイテム）"
    fi
}

#######################################
# すべての設定を復元
# Arguments:
#   $1 - バックアップディレクトリパス
#######################################
restore_all() {
    local backup_path="$1"
    
    restore_nvim "$backup_path"
    restore_shell "$backup_path"
    restore_terminal "$backup_path"
    restore_cli_tools "$backup_path"
}

#######################################
# バックアップ情報を表示
# Arguments:
#   $1 - バックアップディレクトリパス
#######################################
show_backup_info() {
    local backup_path="$1"
    local manifest="$backup_path/$BACKUP_MANIFEST_NAME"
    
    log_section "バックアップ情報"
    
    echo "バックアップ: $(basename "$backup_path")"
    
    if [[ -f "$manifest" ]]; then
        if check_command jq; then
            echo "日時: $(jq -r '.timestamp' "$manifest")"
            echo "OS: $(jq -r '.os' "$manifest")"
            echo "OSバージョン: $(jq -r '.os_version' "$manifest")"
            echo "アーキテクチャ: $(jq -r '.architecture' "$manifest")"
            echo "ホスト名: $(jq -r '.hostname' "$manifest")"
            echo "ユーザー: $(jq -r '.user' "$manifest")"
            
            echo ""
            echo "コンポーネント:"
            jq -r '.components | to_entries[] | "  - \(.key): \(.value.type) (\(.value.size))"' "$manifest"
        else
            log_warn "jqがインストールされていないため、詳細情報を表示できません"
        fi
    else
        log_warn "マニフェストファイルが見つかりません"
    fi
    
    echo ""
}

#######################################
# 復元前の確認
# Arguments:
#   $1 - バックアップディレクトリパス
#######################################
confirm_restore() {
    local backup_path="$1"
    
    if [[ "$FORCE" == "true" ]]; then
        return 0
    fi
    
    if [[ "$DRY_RUN" == "true" ]]; then
        return 0
    fi
    
    show_backup_info "$backup_path"
    
    log_warn "以下の設定が復元されます:"
    
    case "$COMPONENT" in
        all)
            echo "  - Neovim設定"
            echo "  - シェル設定（Zsh, Bash）"
            echo "  - ターミナル設定（WezTerm, Starship）"
            echo "  - CLIツール設定（Git, tmux等）"
            ;;
        nvim)
            echo "  - Neovim設定"
            ;;
        shell)
            echo "  - シェル設定（Zsh, Bash）"
            ;;
        terminal)
            echo "  - ターミナル設定（WezTerm, Starship）"
            ;;
        cli)
            echo "  - CLIツール設定（Git, tmux等）"
            ;;
    esac
    
    echo ""
    log_warn "既存の設定は .before_restore バックアップとして保存されます"
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
    log_section "復元完了"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "ドライランモードで実行しました"
        log_info "実際に復元するには --dry-run オプションを外してください"
    else
        log_success "復元が完了しました"
        log_info "シェルを再起動して変更を反映してください"
    fi
}

#######################################
# メイン処理
#######################################
main() {
    # 引数の解析
    parse_arguments "$@"
    
    # ヘッダー表示
    log_section "Dotfiles 復元スクリプト"
    
    # バックアップ一覧表示のみの場合
    if [[ "$LIST_ONLY" == "true" ]]; then
        list_backups
        exit 0
    fi
    
    # バックアップの選択
    local backup_path
    backup_path="$(select_backup)"
    
    # バックアップの検証
    if ! validate_backup "$backup_path"; then
        log_error "バックアップが無効です"
        exit 1
    fi
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "モード: ドライラン（実際には復元しません）"
    fi
    
    log_info "コンポーネント: $COMPONENT"
    
    # 確認
    confirm_restore "$backup_path"
    
    # 復元の実行
    case "$COMPONENT" in
        all)
            restore_all "$backup_path"
            ;;
        nvim)
            restore_nvim "$backup_path"
            ;;
        shell)
            restore_shell "$backup_path"
            ;;
        terminal)
            restore_terminal "$backup_path"
            ;;
        cli)
            restore_cli_tools "$backup_path"
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
