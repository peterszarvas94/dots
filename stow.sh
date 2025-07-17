#!/usr/bin/env bash

set -euo pipefail

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly STOW_DIR="$SCRIPT_DIR/stow"
readonly TARGET_DIR="$HOME"

# Script options
FORCE_MODE=false
BACKUP_MODE=false
DRY_RUN=false

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

# Show usage information
show_usage() {
    cat << EOF
Usage: $0 [OPTION]

Deploy dotfiles using GNU Stow for the specified platform.

Options:
  --mac           Deploy dotfiles for macOS
  --arch          Deploy dotfiles for Arch Linux
  --ubuntu        Deploy dotfiles for Ubuntu Linux
  --force        Skip confirmation prompts and overwrite existing configs
  --backup       Backup existing configs before overwriting
  --dry-run      Show what would be done without making changes
  -h, --help     Show this help message

Examples:
  $0 --mac              # Deploy for macOS
  $0 --arch --backup    # Deploy for Arch Linux with backup
  $0 --ubuntu --dry-run # Preview Ubuntu deployment
EOF
}

# Backup existing config
backup_config() {
    local path="$1"
    local backup_dir="$HOME/.config/dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
    
    if [[ -e "$path" ]]; then
        mkdir -p "$backup_dir"
        local backup_path="$backup_dir/$(basename "$path")"
        log_info "Backing up: $path -> $backup_path"
        if [[ "$DRY_RUN" == false ]]; then
            cp -r "$path" "$backup_path"
        fi
    fi
}

# Safe remove function with logging and confirmation
safe_remove() {
    local path="$1"
    
    if [[ ! -e "$path" ]]; then
        return 0
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY RUN] Would remove: $path"
        return 0
    fi
    
    if [[ "$BACKUP_MODE" == true ]]; then
        backup_config "$path"
    fi
    
    if [[ "$FORCE_MODE" == false ]]; then
        echo -n "Remove existing config at $path? [y/N] "
        read -r response
        case "$response" in
            [yY]|[yY][eE][sS])
                ;;
            *)
                log_warning "Skipping removal of: $path"
                return 1
                ;;
        esac
    fi
    
    log_info "Removing existing: $path"
    rm -rf "$path"
}

# Safe stow function with error handling
safe_stow() {
    local package="$1"
    local package_path="$STOW_DIR/$package"
    
    if [[ ! -d "$package_path" ]]; then
        log_warning "Package '$package' not found in $STOW_DIR"
        return 1
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY RUN] Would stow package: $package"
        stow --dir="$STOW_DIR" --target="$TARGET_DIR" --no "$package" 2>/dev/null || true
        return 0
    fi
    
    log_info "Stowing package: $package"
    if stow --dir="$STOW_DIR" --target="$TARGET_DIR" "$package" 2>/dev/null; then
        log_success "Successfully stowed: $package"
    else
        log_error "Failed to stow: $package"
        return 1
    fi
}

# Deploy common packages shared across all platforms
deploy_common_packages() {
    log_info "Deploying common packages..."
    
    # Git configuration
    safe_remove "$HOME/.gitignore"
    safe_remove "$HOME/.config/git"
    safe_stow "git"
    
    # Zsh configuration
    safe_remove "$HOME/.zshrc"
    safe_remove "$HOME/.zsh"
    safe_stow "zsh"
    
    # Neovim configuration
    safe_remove "$HOME/.config/nvim"
    safe_stow "nvim"
    
    # OpenCode configuration
    safe_remove "$HOME/.config/opencode"
    safe_stow "opencode"
    
    # Scripts
    safe_remove "$HOME/.local/bin"
    safe_stow "scripts"
    
    # Alacritty terminal
    safe_remove "$HOME/.config/alacritty"
    safe_stow "alacritty"
    
    # Tmux configuration
    safe_remove "$HOME/.config/.tmux.conf"
    safe_remove "$HOME/.config/.tmux"
    safe_stow "tmux"
}

# Deploy platform-specific packages for macOS
deploy_mac_packages() {
    log_info "Deploying macOS-specific packages..."
    
    # Aerospace window manager
    safe_remove "$HOME/.config/aerospace"
    safe_stow "aerospace"
    
    # macOS-specific zsh config (includes .zprofile)
    safe_remove "$HOME/.zprofile"
    safe_stow "zsh-mac"

    safe_remove "$HOME/ruby"
    safe_stow "ruby"
}

# Deploy platform-specific packages for Arch Linux
deploy_arch_packages() {
    log_info "Deploying Arch Linux-specific packages..."
    
    # Hyprland window manager
    safe_remove "$HOME/.config/hypr"
    safe_stow "hypr"
    
    # Waybar status bar
    safe_remove "$HOME/.config/waybar"
    safe_stow "waybar"
    
    # Arch-specific zsh config (includes .zprofile)
    safe_remove "$HOME/.zprofile"
    safe_stow "zsh-arch"
}

# Deploy platform-specific packages for Ubuntu
deploy_ubuntu_packages() {
    log_info "Deploying Ubuntu-specific packages..."
    
    # Ubuntu-specific zsh config (includes .zprofile)
    safe_remove "$HOME/.zprofile"
    safe_stow "zsh-ubuntu"
}

# Main deployment function
deploy_dotfiles() {
    local platform="$1"
    
    log_info "Starting dotfiles deployment for platform: $platform"
    
    # Deploy common packages first
    deploy_common_packages
    
    # Deploy platform-specific packages
    case "$platform" in
        mac)
            deploy_mac_packages
            ;;
        arch)
            deploy_arch_packages
            ;;
        ubuntu)
            deploy_ubuntu_packages
            ;;
        *)
            log_error "Unknown platform: $platform"
            return 1
            ;;
    esac
    
    log_success "Dotfiles deployment completed successfully!"
}

# Parse command line arguments
parse_arguments() {
    local platform=""
    
    if [[ $# -eq 0 ]]; then
        log_error "No platform specified"
        show_usage
        exit 1
    fi
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --mac)
                platform="mac"
                shift
                ;;
            --arch)
                platform="arch"
                shift
                ;;
            --ubuntu)
                platform="ubuntu"
                shift
                ;;
            --force)
                FORCE_MODE=true
                shift
                ;;
            --backup)
                BACKUP_MODE=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    if [[ -z "$platform" ]]; then
        log_error "No platform specified"
        show_usage
        exit 1
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "Running in dry-run mode - no changes will be made"
    fi
    
    if [[ "$BACKUP_MODE" == true ]]; then
        log_info "Backup mode enabled - existing configs will be backed up"
    fi
    
    deploy_dotfiles "$platform"
}

# Main execution
main() {
    # Check if stow is installed
    if ! command -v stow &> /dev/null; then
        log_error "GNU Stow is not installed. Please install it first."
        exit 1
    fi
    
    # Check if we're in the right directory
    if [[ ! -d "$STOW_DIR" ]]; then
        log_error "Stow directory not found: $STOW_DIR"
        log_error "Please run this script from the dotfiles repository root."
        exit 1
    fi
    
    parse_arguments "$@"
}

# Run main function with all arguments
main "$@"
