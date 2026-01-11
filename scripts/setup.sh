#!/usr/bin/env bash
# setup.sh - メインセットアップスクリプト
# dotfilesの設定を適用し、必要なツールをインストール

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
SCRIPT_VERSION="3.0.0"
DRY_RUN=false
FORCE=false
COMPONENT="all"
INSTALL_DEPENDENCIES=false
CREATE_BACKUP=true

#######################################
# 使用方法を表示
#######################################
show_usage() {
    cat <<EOF
使用方法: $(basename "$0") [オプション] [コンポーネント]

dotfilesの設定を適用し、必要なツールをインストールします。

コンポーネント:
  --all              すべての設定を適用（デフォルト）
  --nvim             Neovim設定のみ
  --shell            シェル設定のみ（Zsh + Starship）
  --terminal         ターミナル設定のみ（WezTerm）
  --cli              CLIツール設定のみ（Git, tmux等）

オプション:
  --install          依存関係もインストール
  --dry-run          実際には適用せず、何が行われるか表示
  --no-backup        バックアップを作成しない
  --force            確認なしで実行
  -h, --help         このヘルプを表示

例:
  # すべての設定を適用（設定ファイルのみ）
  $(basename "$0") --all

  # 依存関係もインストールしてフルセットアップ
  $(basename "$0") --all --install

  # Neovim設定のみ適用
  $(basename "$0") --nvim

  # ドライランモード
  $(basename "$0") --all --dry-run

EOF
}

#######################################
# 引数を解析
#######################################
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
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
            --install)
                INSTALL_DEPENDENCIES=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --no-backup)
                CREATE_BACKUP=false
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
# 必須要件を確認
#######################################
check_requirements() {
    log_section "必須要件の確認"
    
    local missing_commands=()
    
    # 基本コマンドの確認
    local required_commands=("git" "curl")
    
    for cmd in "${required_commands[@]}"; do
        if ! check_command "$cmd"; then
            missing_commands+=("$cmd")
        fi
    done
    
    if [[ ${#missing_commands[@]} -gt 0 ]]; then
        log_error "必須コマンドが見つかりません: ${missing_commands[*]}"
        log_info "以下のコマンドをインストールしてください"
        for cmd in "${missing_commands[@]}"; do
            echo "  - $cmd"
        done
        return 1
    fi
    
    log_success "すべての必須要件が満たされています"
    return 0
}

#######################################
# 依存関係をインストール
#######################################
install_dependencies() {
    log_section "依存関係のインストール"
    
    local os
    os="$(detect_os)"
    local pkg_manager
    pkg_manager="$(detect_package_manager)"
    
    log_info "OS: $os"
    log_info "パッケージマネージャ: $pkg_manager"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] 依存関係のインストールをスキップ"
        return 0
    fi
    
    case "$os" in
        "$OS_MACOS")
            install_dependencies_macos
            ;;
        "$OS_LINUX"|"$OS_WSL")
            install_dependencies_linux
            ;;
        *)
            log_error "未対応のOS: $os"
            return 1
            ;;
    esac
}

#######################################
# macOS用の依存関係をインストール
#######################################
install_dependencies_macos() {
    # Homebrewのインストール確認
    if ! check_command brew; then
        log_info "Homebrewをインストールしています..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    log_info "パッケージをインストールしています..."
    
    local packages=()
    
    case "$COMPONENT" in
        all|nvim)
            packages+=("neovim" "ripgrep" "fd" "lazygit")
            ;;
    esac
    
    case "$COMPONENT" in
        all|shell)
            packages+=("zsh" "sheldon" "starship")
            ;;
    esac
    
    case "$COMPONENT" in
        all|terminal)
            packages+=("--cask wezterm")
            ;;
    esac
    
    case "$COMPONENT" in
        all|cli)
            packages+=("git" "tmux" "fzf" "bat" "eza")
            ;;
    esac
    
    if [[ ${#packages[@]} -gt 0 ]]; then
        brew install "${packages[@]}" || log_warn "一部のパッケージのインストールに失敗しました"
    fi
    
    log_success "依存関係のインストールが完了しました"
}

#######################################
# Linux用の依存関係をインストール
#######################################
install_dependencies_linux() {
    local distro
    distro="$(detect_linux_distro)"
    
    log_info "ディストリビューション: $distro"
    
    case "$distro" in
        ubuntu|debian)
            install_dependencies_debian
            ;;
        fedora|rhel)
            install_dependencies_fedora
            ;;
        arch|manjaro)
            install_dependencies_arch
            ;;
        *)
            log_warn "未対応のディストリビューション: $distro"
            log_info "手動でパッケージをインストールしてください"
            return 1
            ;;
    esac
}

#######################################
# Debian/Ubuntu用の依存関係をインストール
#######################################
install_dependencies_debian() {
    sudo apt update
    
    local packages=()
    
    case "$COMPONENT" in
        all|nvim)
            packages+=("neovim" "ripgrep" "fd-find")
            ;;
    esac
    
    case "$COMPONENT" in
        all|shell)
            packages+=("zsh")
            ;;
    esac
    
    case "$COMPONENT" in
        all|cli)
            packages+=("git" "tmux" "fzf")
            ;;
    esac
    
    if [[ ${#packages[@]} -gt 0 ]]; then
        sudo apt install -y "${packages[@]}" || log_warn "一部のパッケージのインストールに失敗しました"
    fi
    
    # Sheldonのインストール
    if [[ "$COMPONENT" == "all" ]] || [[ "$COMPONENT" == "shell" ]]; then
        if ! check_command sheldon; then
            log_info "Sheldonをインストールしています..."
            curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh | \
                bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
        fi
    fi
    
    # Starshipのインストール
    if [[ "$COMPONENT" == "all" ]] || [[ "$COMPONENT" == "shell" ]]; then
        if ! check_command starship; then
            log_info "Starshipをインストールしています..."
            curl -sS https://starship.rs/install.sh | sh -s -- --yes
        fi
    fi
    
    log_success "依存関係のインストールが完了しました"
}

#######################################
# Fedora/RHEL用の依存関係をインストール
#######################################
install_dependencies_fedora() {
    log_warn "Fedora/RHELのサポートは未実装です"
    return 1
}

#######################################
# Arch用の依存関係をインストール
#######################################
install_dependencies_arch() {
    log_warn "Archのサポートは未実装です"
    return 1
}

#######################################
# Neovim設定を適用
#######################################
setup_nvim() {
    log_section "Neovim設定の適用"
    
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"
    local nvim_config_src="$dotfiles_root/nvim"
    local nvim_config_dest="$(get_config_dir nvim)"
    
    if [[ ! -d "$nvim_config_src" ]]; then
        log_warn "Neovim設定が見つかりません: $nvim_config_src"
        log_info "後で実装します"
        return 0
    fi
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] Neovim設定を適用: $nvim_config_src -> $nvim_config_dest"
        return 0
    fi
    
    # シンボリックリンクの作成
    if safe_symlink "$nvim_config_src" "$nvim_config_dest" "$CREATE_BACKUP"; then
        log_success "Neovim設定を適用しました"
    else
        log_error "Neovim設定の適用に失敗しました"
        return 1
    fi
}

#######################################
# シェル設定を適用
#######################################
setup_shell() {
    log_section "シェル設定の適用"
    
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"
    
    # Zsh設定
    local zshrc_src="$dotfiles_root/zsh/zshrc"
    local zshrc_dest="$HOME/.zshrc"
    
    if [[ -f "$zshrc_src" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "[DRY RUN] Zsh設定を適用: $zshrc_src -> $zshrc_dest"
        else
            if safe_symlink "$zshrc_src" "$zshrc_dest" "$CREATE_BACKUP"; then
                log_success "Zsh設定を適用しました"
            fi
        fi
    fi
    
    # Sheldon設定
    local sheldon_src="$dotfiles_root/zsh/sheldon"
    local sheldon_dest="$(get_config_dir sheldon)"
    
    if [[ -d "$sheldon_src" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "[DRY RUN] Sheldon設定を適用: $sheldon_src -> $sheldon_dest"
        else
            if safe_symlink "$sheldon_src" "$sheldon_dest" "$CREATE_BACKUP"; then
                log_success "Sheldon設定を適用しました"
            fi
        fi
    fi
    
    # Starship設定
    local starship_src="$dotfiles_root/starship"
    local starship_dest="$(get_config_dir)"
    
    if [[ -d "$starship_src" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "[DRY RUN] Starship設定を適用予定"
        else
            log_info "Starship設定は後で実装します"
        fi
    fi
}

#######################################
# ターミナル設定を適用
#######################################
setup_terminal() {
    log_section "ターミナル設定の適用"
    
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"
    
    # WezTerm設定
    local wezterm_src="$dotfiles_root/wezterm"
    local wezterm_dest="$(get_config_dir wezterm)"
    
    if [[ -d "$wezterm_src" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "[DRY RUN] WezTerm設定を適用予定"
        else
            log_info "WezTerm設定は後で実装します"
        fi
    else
        log_info "WezTerm設定は後で実装します"
    fi
}

#######################################
# CLIツール設定を適用
#######################################
setup_cli_tools() {
    log_section "CLIツール設定の適用"
    
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"
    
    log_info "CLIツール設定は後で実装します"
}

#######################################
# すべての設定を適用
#######################################
setup_all() {
    setup_nvim
    setup_shell
    setup_terminal
    setup_cli_tools
}

#######################################
# セットアップ前の確認
#######################################
confirm_setup() {
    if [[ "$FORCE" == "true" ]]; then
        return 0
    fi
    
    if [[ "$DRY_RUN" == "true" ]]; then
        return 0
    fi
    
    echo ""
    log_warn "以下の設定が適用されます:"
    
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
    
    if [[ "$CREATE_BACKUP" == "true" ]]; then
        log_info "既存設定のバックアップが作成されます"
    else
        log_warn "バックアップは作成されません"
    fi
    
    if [[ "$INSTALL_DEPENDENCIES" == "true" ]]; then
        log_info "依存関係もインストールされます"
    fi
    
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
    log_section "セットアップ完了"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "ドライランモードで実行しました"
        log_info "実際にセットアップするには --dry-run オプションを外してください"
    else
        log_success "セットアップが完了しました"
        
        echo ""
        log_info "次のステップ:"
        echo "  1. シェルを再起動: exec \$SHELL"
        echo "  2. 設定を確認: $(basename "$0") --help"
        echo "  3. 検証を実行: ./scripts/verify-setup.sh"
    fi
}

#######################################
# メイン処理
#######################################
main() {
    # 引数の解析
    parse_arguments "$@"
    
    # ヘッダー表示
    log_section "Dotfiles セットアップスクリプト v${SCRIPT_VERSION}"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "モード: ドライラン（実際には適用しません）"
    fi
    
    log_info "コンポーネント: $COMPONENT"
    
    # システム情報の表示
    log_debug "OS: $(detect_os)"
    log_debug "設定ディレクトリ: $(get_config_dir)"
    
    # 必須要件の確認
    if ! check_requirements; then
        exit 1
    fi
    
    # 確認
    confirm_setup
    
    # バックアップの作成
    if [[ "$CREATE_BACKUP" == "true" ]] && [[ "$DRY_RUN" == "false" ]]; then
        log_section "既存設定のバックアップ"
        if ! create_backup "$COMPONENT"; then
            log_warn "バックアップの作成に失敗しました"
            if ! confirm "バックアップなしで続行しますか？" "n"; then
                log_info "キャンセルしました"
                exit 1
            fi
        fi
    fi
    
    # 依存関係のインストール
    if [[ "$INSTALL_DEPENDENCIES" == "true" ]]; then
        install_dependencies
    fi
    
    # セットアップの実行
    case "$COMPONENT" in
        all)
            setup_all
            ;;
        nvim)
            setup_nvim
            ;;
        shell)
            setup_shell
            ;;
        terminal)
            setup_terminal
            ;;
        cli)
            setup_cli_tools
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
