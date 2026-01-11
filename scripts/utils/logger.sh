#!/usr/bin/env bash
# logger.sh - ログ機能
# ファイル出力、ログローテーション、構造化ログを提供

set -euo pipefail

# 多重読み込み防止
if [[ -n "${_LOGGER_SH_LOADED:-}" ]]; then
    return 0
fi
readonly _LOGGER_SH_LOADED=1

# common.shの読み込み
_UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$_UTILS_DIR/common.sh"

# ログ設定のデフォルト値
LOG_DIR="${LOG_DIR:-$(get_dotfiles_root)/logs}"
LOG_FILE="${LOG_FILE:-}"
LOG_MAX_SIZE="${LOG_MAX_SIZE:-10485760}"  # 10MB
LOG_MAX_FILES="${LOG_MAX_FILES:-5}"
LOG_TO_FILE="${LOG_TO_FILE:-false}"
LOG_TIMESTAMP_FORMAT="${LOG_TIMESTAMP_FORMAT:-%Y-%m-%d %H:%M:%S}"

#######################################
# ログシステムの初期化
# Arguments:
#   $1 - ログファイル名（オプション）
# Returns:
#   0 - 成功
#   1 - 失敗
#######################################
setup_logging() {
    local log_filename="${1:-dotfiles.log}"
    
    # ログディレクトリの作成
    if ! safe_mkdir "$LOG_DIR"; then
        log_warn "ログディレクトリの作成に失敗しました: $LOG_DIR"
        LOG_TO_FILE="false"
        return 1
    fi
    
    # ログファイルパスの設定
    LOG_FILE="$LOG_DIR/$log_filename"
    LOG_TO_FILE="true"
    
    # ログファイルの初期化
    if [[ ! -f "$LOG_FILE" ]]; then
        touch "$LOG_FILE" 2>/dev/null || {
            log_warn "ログファイルの作成に失敗しました: $LOG_FILE"
            LOG_TO_FILE="false"
            return 1
        }
    fi
    
    # ログローテーションの実行
    rotate_logs
    
    log_debug "ログシステムを初期化しました: $LOG_FILE"
    return 0
}

#######################################
# ファイルにログを出力
# Arguments:
#   $1 - ログレベル
#   $2 - メッセージ
# Returns:
#   0 - 成功
#   1 - 失敗
#######################################
log_to_file() {
    local level="$1"
    shift
    local message="$*"
    
    if [[ "$LOG_TO_FILE" != "true" ]] || [[ -z "$LOG_FILE" ]]; then
        return 0
    fi
    
    local timestamp
    timestamp="$(date +"$LOG_TIMESTAMP_FORMAT")"
    
    # ログエントリの作成
    local log_entry="[$timestamp] [$level] $message"
    
    # ファイルに追記
    echo "$log_entry" >> "$LOG_FILE" 2>/dev/null || {
        log_warn "ログファイルへの書き込みに失敗しました"
        return 1
    }
    
    return 0
}

#######################################
# 情報ログ（ファイル出力対応版）
# Arguments:
#   $@ - メッセージ
#######################################
log_info_file() {
    log_info "$@"
    log_to_file "INFO" "$@"
}

#######################################
# 成功ログ（ファイル出力対応版）
# Arguments:
#   $@ - メッセージ
#######################################
log_success_file() {
    log_success "$@"
    log_to_file "SUCCESS" "$@"
}

#######################################
# エラーログ（ファイル出力対応版）
# Arguments:
#   $@ - メッセージ
#######################################
log_error_file() {
    log_error "$@"
    log_to_file "ERROR" "$@"
}

#######################################
# 警告ログ（ファイル出力対応版）
# Arguments:
#   $@ - メッセージ
#######################################
log_warn_file() {
    log_warn "$@"
    log_to_file "WARN" "$@"
}

#######################################
# デバッグログ（ファイル出力対応版）
# Arguments:
#   $@ - メッセージ
#######################################
log_debug_file() {
    log_debug "$@"
    log_to_file "DEBUG" "$@"
}

#######################################
# ログファイルのローテーション
# Returns:
#   0 - 成功
#   1 - 失敗
#######################################
rotate_logs() {
    if [[ -z "$LOG_FILE" ]] || [[ ! -f "$LOG_FILE" ]]; then
        return 0
    fi
    
    # ファイルサイズの確認
    local file_size
    file_size="$(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null || echo 0)"
    
    if [[ "$file_size" -lt "$LOG_MAX_SIZE" ]]; then
        return 0
    fi
    
    log_debug "ログファイルをローテーションします: $LOG_FILE"
    
    # 古いログファイルの削除
    local max_index=$((LOG_MAX_FILES - 1))
    if [[ -f "${LOG_FILE}.${max_index}" ]]; then
        rm -f "${LOG_FILE}.${max_index}"
    fi
    
    # ログファイルのローテーション
    for ((i = max_index - 1; i >= 1; i--)); do
        if [[ -f "${LOG_FILE}.$i" ]]; then
            mv "${LOG_FILE}.$i" "${LOG_FILE}.$((i + 1))"
        fi
    done
    
    # 現在のログファイルを.1にリネーム
    mv "$LOG_FILE" "${LOG_FILE}.1"
    
    # 新しいログファイルを作成
    touch "$LOG_FILE"
    
    log_debug "ログローテーションが完了しました"
    return 0
}

#######################################
# ログファイルの一覧を表示
#######################################
list_log_files() {
    if [[ ! -d "$LOG_DIR" ]]; then
        log_warn "ログディレクトリが存在しません: $LOG_DIR"
        return 1
    fi
    
    log_section "ログファイル一覧"
    
    local log_files
    log_files=($(find "$LOG_DIR" -type f -name "*.log*" | sort -r))
    
    if [[ ${#log_files[@]} -eq 0 ]]; then
        log_info "ログファイルが見つかりません"
        return 0
    fi
    
    for log_file in "${log_files[@]}"; do
        local size
        size="$(stat -f%z "$log_file" 2>/dev/null || stat -c%s "$log_file" 2>/dev/null || echo 0)"
        local size_mb
        size_mb="$(echo "scale=2; $size / 1048576" | bc 2>/dev/null || echo "0")"
        
        local mtime
        if [[ "$(uname -s)" == "Darwin" ]]; then
            mtime="$(stat -f%Sm -t '%Y-%m-%d %H:%M:%S' "$log_file")"
        else
            mtime="$(stat -c%y "$log_file" | cut -d. -f1)"
        fi
        
        echo "  $(basename "$log_file")"
        echo "    サイズ: ${size_mb}MB"
        echo "    更新日時: $mtime"
    done
}

#######################################
# ログファイルの内容を表示
# Arguments:
#   $1 - 表示する行数（オプション、デフォルトは50）
#######################################
show_log() {
    local lines="${1:-50}"
    
    if [[ -z "$LOG_FILE" ]] || [[ ! -f "$LOG_FILE" ]]; then
        log_error "ログファイルが見つかりません: $LOG_FILE"
        return 1
    fi
    
    log_section "最新のログ（最後の${lines}行）"
    tail -n "$lines" "$LOG_FILE"
}

#######################################
# ログファイルをクリア
# Returns:
#   0 - 成功
#   1 - 失敗
#######################################
clear_logs() {
    if [[ ! -d "$LOG_DIR" ]]; then
        log_info "ログディレクトリが存在しません"
        return 0
    fi
    
    if ! confirm "すべてのログファイルを削除しますか？" "n"; then
        log_info "キャンセルしました"
        return 0
    fi
    
    log_info "ログファイルを削除しています..."
    
    local deleted_count=0
    while IFS= read -r -d '' log_file; do
        rm -f "$log_file"
        ((deleted_count++))
    done < <(find "$LOG_DIR" -type f -name "*.log*" -print0)
    
    log_success "${deleted_count}個のログファイルを削除しました"
    return 0
}

#######################################
# JSON形式のログエントリを出力
# Arguments:
#   $1 - ログレベル
#   $2 - メッセージ
#   $3 - 追加データ（JSON形式、オプション）
#######################################
log_json() {
    local level="$1"
    local message="$2"
    local extra_data="${3:-{}}"
    
    local timestamp
    timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    
    # JSON形式のログエントリ
    local json_entry
    json_entry=$(cat <<EOF
{
  "timestamp": "$timestamp",
  "level": "$level",
  "message": "$message",
  "data": $extra_data
}
EOF
)
    
    if [[ "$LOG_TO_FILE" == "true" ]] && [[ -n "$LOG_FILE" ]]; then
        echo "$json_entry" >> "$LOG_FILE"
    else
        echo "$json_entry"
    fi
}

#######################################
# 構造化ログの開始
# Arguments:
#   $1 - 操作名
# Returns:
#   操作ID
#######################################
log_operation_start() {
    local operation="$1"
    local operation_id
    operation_id="$(date +%s)_$$"
    
    log_json "INFO" "Operation started: $operation" "{\"operation_id\": \"$operation_id\", \"operation\": \"$operation\"}"
    
    echo "$operation_id"
}

#######################################
# 構造化ログの終了
# Arguments:
#   $1 - 操作ID
#   $2 - ステータス（success/failure）
#   $3 - メッセージ（オプション）
#######################################
log_operation_end() {
    local operation_id="$1"
    local status="$2"
    local message="${3:-Operation completed}"
    
    log_json "INFO" "$message" "{\"operation_id\": \"$operation_id\", \"status\": \"$status\"}"
}

# スクリプトがsourceされた場合は関数のみ提供、直接実行された場合はテスト実行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    log_section "logger.sh テスト"
    
    # ログシステムの初期化
    setup_logging "test.log"
    
    # 各種ログの出力
    log_info_file "これは情報ログです"
    log_success_file "これは成功ログです"
    log_warn_file "これは警告ログです"
    log_error_file "これはエラーログです"
    log_debug_file "これはデバッグログです"
    
    # 構造化ログのテスト
    operation_id=$(log_operation_start "test_operation")
    sleep 1
    log_operation_end "$operation_id" "success" "テスト操作が完了しました"
    
    # ログファイルの一覧表示
    list_log_files
    
    # ログの表示
    show_log 10
    
    log_success "logger.sh のテストが完了しました"
fi
