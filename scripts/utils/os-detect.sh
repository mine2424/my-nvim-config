#!/usr/bin/env bash
# os-detect.sh - OS検出とプラットフォーム固有の情報取得
# クロスプラットフォーム対応のための関数を提供

set -euo pipefail

# 多重読み込み防止
if [[ -n "${_OS_DETECT_SH_LOADED:-}" ]]; then
    return 0
fi
readonly _OS_DETECT_SH_LOADED=1

# common.shの読み込み
_UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$_UTILS_DIR/common.sh"

# OS種別の定数
readonly OS_MACOS="macos"
readonly OS_LINUX="linux"
readonly OS_WINDOWS="windows"
readonly OS_WSL="wsl"
readonly OS_UNKNOWN="unknown"

# パッケージマネージャの定数
readonly PKG_HOMEBREW="homebrew"
readonly PKG_APT="apt"
readonly PKG_DNF="dnf"
readonly PKG_YUM="yum"
readonly PKG_PACMAN="pacman"
readonly PKG_ZYPPER="zypper"
readonly PKG_UNKNOWN="unknown"

#######################################
# OSの種類を検出
# Returns:
#   OS種別（macos/linux/wsl/windows/unknown）
#######################################
detect_os() {
    local os_type
    
    case "$(uname -s)" in
        Darwin*)
            os_type="$OS_MACOS"
            ;;
        Linux*)
            # WSLの検出
            if grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null; then
                os_type="$OS_WSL"
            else
                os_type="$OS_LINUX"
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*)
            os_type="$OS_WINDOWS"
            ;;
        *)
            os_type="$OS_UNKNOWN"
            ;;
    esac
    
    echo "$os_type"
}

#######################################
# Linuxディストリビューションを検出
# Returns:
#   ディストリビューション名（ubuntu/debian/fedora/arch等）
#######################################
detect_linux_distro() {
    local distro="unknown"
    
    if [[ -f /etc/os-release ]]; then
        # shellcheck disable=SC1091
        source /etc/os-release
        distro="${ID:-unknown}"
    elif [[ -f /etc/lsb-release ]]; then
        # shellcheck disable=SC1091
        source /etc/lsb-release
        distro="${DISTRIB_ID:-unknown}"
    elif [[ -f /etc/debian_version ]]; then
        distro="debian"
    elif [[ -f /etc/fedora-release ]]; then
        distro="fedora"
    elif [[ -f /etc/redhat-release ]]; then
        distro="rhel"
    elif [[ -f /etc/arch-release ]]; then
        distro="arch"
    fi
    
    echo "$distro" | tr '[:upper:]' '[:lower:]'
}

#######################################
# パッケージマネージャを検出
# Returns:
#   パッケージマネージャ名
#######################################
detect_package_manager() {
    local os
    os="$(detect_os)"
    
    case "$os" in
        "$OS_MACOS")
            if check_command brew; then
                echo "$PKG_HOMEBREW"
            else
                echo "$PKG_UNKNOWN"
            fi
            ;;
        "$OS_LINUX"|"$OS_WSL")
            if check_command apt-get; then
                echo "$PKG_APT"
            elif check_command dnf; then
                echo "$PKG_DNF"
            elif check_command yum; then
                echo "$PKG_YUM"
            elif check_command pacman; then
                echo "$PKG_PACMAN"
            elif check_command zypper; then
                echo "$PKG_ZYPPER"
            else
                echo "$PKG_UNKNOWN"
            fi
            ;;
        *)
            echo "$PKG_UNKNOWN"
            ;;
    esac
}

#######################################
# 設定ファイルディレクトリを取得
# Arguments:
#   $1 - アプリケーション名（オプション）
# Returns:
#   設定ディレクトリパス
#######################################
get_config_dir() {
    local app_name="${1:-}"
    local config_dir
    
    # XDG Base Directory仕様に従う
    config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
    
    if [[ -n "$app_name" ]]; then
        echo "$config_dir/$app_name"
    else
        echo "$config_dir"
    fi
}

#######################################
# データディレクトリを取得
# Arguments:
#   $1 - アプリケーション名（オプション）
# Returns:
#   データディレクトリパス
#######################################
get_data_dir() {
    local app_name="${1:-}"
    local data_dir
    
    # XDG Base Directory仕様に従う
    data_dir="${XDG_DATA_HOME:-$HOME/.local/share}"
    
    if [[ -n "$app_name" ]]; then
        echo "$data_dir/$app_name"
    else
        echo "$data_dir"
    fi
}

#######################################
# キャッシュディレクトリを取得
# Arguments:
#   $1 - アプリケーション名（オプション）
# Returns:
#   キャッシュディレクトリパス
#######################################
get_cache_dir() {
    local app_name="${1:-}"
    local cache_dir
    
    # XDG Base Directory仕様に従う
    cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"
    
    if [[ -n "$app_name" ]]; then
        echo "$cache_dir/$app_name"
    else
        echo "$cache_dir"
    fi
}

#######################################
# ホームディレクトリを取得
# Returns:
#   ホームディレクトリパス
#######################################
get_home_dir() {
    echo "$HOME"
}

#######################################
# シェル設定ファイルのパスを取得
# Arguments:
#   $1 - シェル名（bash/zsh等、オプション）
# Returns:
#   シェル設定ファイルパス
#######################################
get_shell_config_path() {
    local shell_name="${1:-$(basename "$SHELL")}"
    local config_path
    
    case "$shell_name" in
        bash)
            config_path="$HOME/.bashrc"
            ;;
        zsh)
            config_path="$HOME/.zshrc"
            ;;
        fish)
            config_path="$(get_config_dir fish)/config.fish"
            ;;
        *)
            config_path="$HOME/.${shell_name}rc"
            ;;
    esac
    
    echo "$config_path"
}

#######################################
# OSのバージョン情報を取得
# Returns:
#   OSバージョン情報
#######################################
get_os_version() {
    local os
    os="$(detect_os)"
    
    case "$os" in
        "$OS_MACOS")
            sw_vers -productVersion
            ;;
        "$OS_LINUX"|"$OS_WSL")
            if [[ -f /etc/os-release ]]; then
                # shellcheck disable=SC1091
                source /etc/os-release
                echo "${VERSION_ID:-unknown}"
            else
                echo "unknown"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

#######################################
# CPUアーキテクチャを取得
# Returns:
#   アーキテクチャ（x86_64/arm64/aarch64等）
#######################################
get_architecture() {
    uname -m
}

#######################################
# Apple Siliconかどうかを判定
# Returns:
#   0 - Apple Silicon
#   1 - それ以外
#######################################
is_apple_silicon() {
    local os
    os="$(detect_os)"
    
    if [[ "$os" == "$OS_MACOS" ]]; then
        local arch
        arch="$(get_architecture)"
        [[ "$arch" == "arm64" ]]
    else
        return 1
    fi
}

#######################################
# WSL環境かどうかを判定
# Returns:
#   0 - WSL環境
#   1 - それ以外
#######################################
is_wsl() {
    local os
    os="$(detect_os)"
    [[ "$os" == "$OS_WSL" ]]
}

#######################################
# パッケージマネージャでパッケージをインストール
# Arguments:
#   $@ - パッケージ名のリスト
# Returns:
#   0 - 成功
#   1 - 失敗
#######################################
install_package() {
    local pkg_manager
    pkg_manager="$(detect_package_manager)"
    
    if [[ "$pkg_manager" == "$PKG_UNKNOWN" ]]; then
        log_error "パッケージマネージャが見つかりません"
        return 1
    fi
    
    log_info "パッケージをインストール: $*"
    
    case "$pkg_manager" in
        "$PKG_HOMEBREW")
            brew install "$@"
            ;;
        "$PKG_APT")
            sudo apt-get update && sudo apt-get install -y "$@"
            ;;
        "$PKG_DNF")
            sudo dnf install -y "$@"
            ;;
        "$PKG_YUM")
            sudo yum install -y "$@"
            ;;
        "$PKG_PACMAN")
            sudo pacman -S --noconfirm "$@"
            ;;
        "$PKG_ZYPPER")
            sudo zypper install -y "$@"
            ;;
        *)
            log_error "未対応のパッケージマネージャ: $pkg_manager"
            return 1
            ;;
    esac
}

#######################################
# システム情報を表示
#######################################
show_system_info() {
    log_section "システム情報"
    
    local os
    os="$(detect_os)"
    
    echo "OS: $os"
    echo "OSバージョン: $(get_os_version)"
    echo "アーキテクチャ: $(get_architecture)"
    
    if [[ "$os" == "$OS_LINUX" ]] || [[ "$os" == "$OS_WSL" ]]; then
        echo "ディストリビューション: $(detect_linux_distro)"
    fi
    
    if [[ "$os" == "$OS_MACOS" ]]; then
        if is_apple_silicon; then
            echo "Apple Silicon: Yes"
        else
            echo "Apple Silicon: No"
        fi
    fi
    
    if is_wsl; then
        echo "WSL: Yes"
    fi
    
    echo "パッケージマネージャ: $(detect_package_manager)"
    echo "設定ディレクトリ: $(get_config_dir)"
    echo "データディレクトリ: $(get_data_dir)"
    echo "キャッシュディレクトリ: $(get_cache_dir)"
    echo "シェル: $SHELL"
    echo "シェル設定: $(get_shell_config_path)"
}

# スクリプトがsourceされた場合は関数のみ提供、直接実行された場合はテスト実行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    show_system_info
fi
