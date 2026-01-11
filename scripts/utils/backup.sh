#!/usr/bin/env bash
# backup.sh - バックアップ機能
# 設定ファイルのバックアップ、復元、管理を提供

set -euo pipefail

# 多重読み込み防止
if [[ -n "${_BACKUP_SH_LOADED:-}" ]]; then
    return 0
fi
readonly _BACKUP_SH_LOADED=1

# 依存スクリプトの読み込み
_UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$_UTILS_DIR/common.sh"
# shellcheck source=./os-detect.sh
source "$_UTILS_DIR/os-detect.sh"

# バックアップ設定
BACKUP_DIR="${BACKUP_DIR:-$(get_dotfiles_root)/backups}"
BACKUP_MANIFEST_NAME="manifest.json"

#######################################
# バックアップディレクトリのパスを取得
# Arguments:
#   $1 - タイムスタンプ（オプション）
# Returns:
#   バックアップディレクトリパス
#######################################
get_backup_path() {
    local timestamp="${1:-$(get_timestamp)}"
    echo "$BACKUP_DIR/$timestamp"
}

#######################################
# バックアップマニフェストを作成
# Arguments:
#   $1 - バックアップディレクトリパス
#   $2... - バックアップされたコンポーネント情報（JSON形式）
# Returns:
#   0 - 成功
#   1 - 失敗
#######################################
create_manifest() {
    local backup_path="$1"
    shift
    local components=("$@")
    
    local manifest_file="$backup_path/$BACKUP_MANIFEST_NAME"
    local timestamp
    timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    local os
    os="$(detect_os)"
    local os_version
    os_version="$(get_os_version)"
    
    # マニフェストのJSON構造を作成
    cat > "$manifest_file" <<EOF
{
  "timestamp": "$timestamp",
  "os": "$os",
  "os_version": "$os_version",
  "architecture": "$(get_architecture)",
  "hostname": "$(hostname)",
  "user": "$USER",
  "components": {
EOF
    
    # コンポーネント情報を追加
    local first=true
    for component in "${components[@]}"; do
        if [[ "$first" == "true" ]]; then
            first=false
        else
            echo "," >> "$manifest_file"
        fi
        echo "    $component" >> "$manifest_file"
    done
    
    # JSONを閉じる
    cat >> "$manifest_file" <<EOF

  }
}
EOF
    
    log_debug "マニフェストを作成しました: $manifest_file"
    return 0
}

#######################################
# ファイルまたはディレクトリをバックアップ
# Arguments:
#   $1 - ソースパス
#   $2 - バックアップディレクトリパス
#   $3 - コンポーネント名
# Returns:
#   0 - 成功（またはソースが存在しない）
#   1 - 失敗
#######################################
backup_item() {
    local source="$1"
    local backup_path="$2"
    local component_name="$3"
    
    # ソースの展開（~を含む場合）
    source="${source/#\~/$HOME}"
    
    # ソースが存在しない場合はスキップ
    if [[ ! -e "$source" ]] && [[ ! -L "$source" ]]; then
        log_debug "スキップ（存在しません）: $source"
        return 0
    fi
    
    # バックアップ先のパスを決定
    local dest="$backup_path/$component_name"
    
    # 親ディレクトリの作成
    local dest_dir
    dest_dir="$(dirname "$dest")"
    safe_mkdir "$dest_dir" || return 1
    
    # バックアップの実行
    log_debug "バックアップ: $source -> $dest"
    
    if [[ -L "$source" ]]; then
        # シンボリックリンクの場合はリンク情報を保存
        local link_target
        link_target="$(readlink "$source")"
        echo "$link_target" > "${dest}.symlink"
    fi
    
    # ファイル/ディレクトリのコピー
    if cp -rL "$source" "$dest" 2>/dev/null; then
        return 0
    else
        log_error "バックアップに失敗しました: $source"
        return 1
    fi
}

#######################################
# コンポーネント情報のJSON文字列を生成
# Arguments:
#   $1 - コンポーネント名
#   $2 - ソースパス
#   $3 - バックアップパス
# Returns:
#   JSON文字列
#######################################
generate_component_json() {
    local name="$1"
    local source="$2"
    local backup_path="$3"
    
    source="${source/#\~/$HOME}"
    
    local size="0"
    local type="missing"
    
    if [[ -e "$source" ]] || [[ -L "$source" ]]; then
        if [[ -d "$source" ]]; then
            type="directory"
            size="$(du -sk "$source" 2>/dev/null | cut -f1 || echo 0)"
            size="${size}KB"
        else
            type="file"
            size="$(stat -f%z "$source" 2>/dev/null || stat -c%s "$source" 2>/dev/null || echo 0)"
            # バイトをKBに変換
            size="$((size / 1024))KB"
        fi
    fi
    
    # JSON文字列を出力
    echo "\"$name\": {\"path\": \"$source\", \"type\": \"$type\", \"size\": \"$size\"}"
}

#######################################
# バックアップを作成
# Arguments:
#   $1 - バックアップするコンポーネント（nvim/shell/terminal/all）
# Returns:
#   0 - 成功
#   1 - 失敗
#######################################
create_backup() {
    local component="${1:-all}"
    
    log_section "バックアップの作成"
    
    # バックアップディレクトリの作成
    local timestamp
    timestamp="$(get_timestamp)"
    local backup_path
    backup_path="$(get_backup_path "$timestamp")"
    
    if ! safe_mkdir "$backup_path"; then
        log_error "バックアップディレクトリの作成に失敗しました"
        return 1
    fi
    
    log_info "バックアップ先: $backup_path"
    
    # バックアップするアイテムの定義
    declare -A backup_items
    declare -a component_jsons
    
    # Neovim
    if [[ "$component" == "nvim" ]] || [[ "$component" == "all" ]]; then
        backup_items["nvim_config"]="$(get_config_dir nvim)"
        backup_items["nvim_data"]="$(get_data_dir nvim)"
        backup_items["nvim_cache"]="$(get_cache_dir nvim)"
    fi
    
    # シェル設定
    if [[ "$component" == "shell" ]] || [[ "$component" == "all" ]]; then
        backup_items["zshrc"]="$HOME/.zshrc"
        backup_items["zshenv"]="$HOME/.zshenv"
        backup_items["zprofile"]="$HOME/.zprofile"
        backup_items["bashrc"]="$HOME/.bashrc"
        backup_items["bash_profile"]="$HOME/.bash_profile"
        backup_items["sheldon"]="$(get_config_dir sheldon)"
    fi
    
    # ターミナル設定
    if [[ "$component" == "terminal" ]] || [[ "$component" == "all" ]]; then
        backup_items["wezterm"]="$(get_config_dir wezterm)"
        backup_items["starship"]="$(get_config_dir starship.toml)"
        backup_items["alacritty"]="$(get_config_dir alacritty)"
    fi
    
    # CLIツール
    if [[ "$component" == "cli" ]] || [[ "$component" == "all" ]]; then
        backup_items["gitconfig"]="$HOME/.gitconfig"
        backup_items["tmux"]="$HOME/.tmux.conf"
        backup_items["vim"]="$HOME/.vimrc"
    fi
    
    # バックアップの実行
    local success_count=0
    local total_count=${#backup_items[@]}
    
    for item_name in "${!backup_items[@]}"; do
        local item_path="${backup_items[$item_name]}"
        
        if backup_item "$item_path" "$backup_path" "$item_name"; then
            ((success_count++))
            # コンポーネント情報をJSON配列に追加
            component_jsons+=("$(generate_component_json "$item_name" "$item_path" "$backup_path")")
        fi
    done
    
    # マニフェストの作成
    if [[ ${#component_jsons[@]} -gt 0 ]]; then
        create_manifest "$backup_path" "${component_jsons[@]}"
    fi
    
    # 結果の表示
    echo ""
    log_success "バックアップが完了しました: $success_count/$total_count アイテム"
    log_info "バックアップ場所: $backup_path"
    
    return 0
}

#######################################
# バックアップの一覧を表示
# Returns:
#   0 - 成功
#   1 - 失敗
#######################################
list_backups() {
    log_section "バックアップ一覧"
    
    if [[ ! -d "$BACKUP_DIR" ]]; then
        log_info "バックアップが見つかりません"
        return 0
    fi
    
    local backups
    backups=($(find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d | sort -r))
    
    if [[ ${#backups[@]} -eq 0 ]]; then
        log_info "バックアップが見つかりません"
        return 0
    fi
    
    echo "見つかったバックアップ: ${#backups[@]}個"
    echo ""
    
    for backup in "${backups[@]}"; do
        local backup_name
        backup_name="$(basename "$backup")"
        local manifest="$backup/$BACKUP_MANIFEST_NAME"
        
        echo "📦 $backup_name"
        
        if [[ -f "$manifest" ]]; then
            # マニフェストから情報を抽出
            if check_command jq; then
                local timestamp os components_count
                timestamp="$(jq -r '.timestamp' "$manifest" 2>/dev/null || echo "unknown")"
                os="$(jq -r '.os' "$manifest" 2>/dev/null || echo "unknown")"
                components_count="$(jq '.components | length' "$manifest" 2>/dev/null || echo "0")"
                
                echo "   日時: $timestamp"
                echo "   OS: $os"
                echo "   コンポーネント数: $components_count"
            else
                echo "   マニフェスト: あり（jqがないため詳細表示不可）"
            fi
        else
            echo "   マニフェスト: なし"
        fi
        
        # サイズ情報
        local size
        size="$(du -sh "$backup" 2>/dev/null | cut -f1 || echo "unknown")"
        echo "   サイズ: $size"
        echo ""
    done
    
    return 0
}

#######################################
# 最新のバックアップを取得
# Returns:
#   最新のバックアップディレクトリパス（存在しない場合は空文字列）
#######################################
get_latest_backup() {
    if [[ ! -d "$BACKUP_DIR" ]]; then
        echo ""
        return 1
    fi
    
    local latest
    latest="$(find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d | sort -r | head -n1)"
    
    echo "$latest"
}

#######################################
# バックアップの検証
# Arguments:
#   $1 - バックアップディレクトリパス
# Returns:
#   0 - 有効
#   1 - 無効
#######################################
validate_backup() {
    local backup_path="$1"
    
    if [[ ! -d "$backup_path" ]]; then
        log_error "バックアップディレクトリが存在しません: $backup_path"
        return 1
    fi
    
    local manifest="$backup_path/$BACKUP_MANIFEST_NAME"
    if [[ ! -f "$manifest" ]]; then
        log_warn "マニフェストファイルが見つかりません"
        return 1
    fi
    
    # JSONの妥当性チェック（jqがある場合）
    if check_command jq; then
        if ! jq empty "$manifest" 2>/dev/null; then
            log_error "マニフェストのJSON形式が不正です"
            return 1
        fi
    fi
    
    log_success "バックアップは有効です"
    return 0
}

#######################################
# 古いバックアップを削除
# Arguments:
#   $1 - 保持する数（デフォルト: 5）
# Returns:
#   0 - 成功
#   1 - 失敗
#######################################
cleanup_old_backups() {
    local keep_count="${1:-5}"
    
    log_section "古いバックアップのクリーンアップ"
    
    if [[ ! -d "$BACKUP_DIR" ]]; then
        log_info "バックアップディレクトリが存在しません"
        return 0
    fi
    
    local backups
    backups=($(find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d | sort -r))
    
    local total_count=${#backups[@]}
    
    if [[ $total_count -le $keep_count ]]; then
        log_info "削除するバックアップはありません（$total_count/$keep_count）"
        return 0
    fi
    
    local delete_count=$((total_count - keep_count))
    log_info "${delete_count}個の古いバックアップを削除します"
    
    # 古いバックアップを削除
    for ((i = keep_count; i < total_count; i++)); do
        local backup="${backups[$i]}"
        log_info "削除: $(basename "$backup")"
        rm -rf "$backup"
    done
    
    log_success "クリーンアップが完了しました"
    return 0
}

# スクリプトがsourceされた場合は関数のみ提供、直接実行された場合はテスト実行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    log_section "backup.sh テスト"
    
    # バックアップ一覧の表示
    list_backups
    
    # 最新のバックアップを取得
    latest=$(get_latest_backup)
    if [[ -n "$latest" ]]; then
        log_info "最新のバックアップ: $(basename "$latest")"
        validate_backup "$latest"
    else
        log_info "バックアップが見つかりません"
    fi
    
    log_success "backup.sh のテストが完了しました"
fi
