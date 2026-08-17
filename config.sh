#!/usr/bin/env bash

set -euo pipefail

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly STOW_DIR="$SCRIPT_DIR/stow"
readonly TARGET_DIR="$HOME"

# Script options
BACKUP_MODE=false
PKGS=()
WITH_DEBLOAT=false
WITH_SERVICES=false
WITH_FONT=false
PLATFORM=""

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

Deploy dotfiles using GNU Stow (auto-detects macOS or Arch Linux/omarchy).

Options:
  --pkg=PACKAGE   Deploy package(s): single, comma list, or 'all'
  --backup       Backup existing configs before overwriting
  --services     Start and enable systemd services (omarchy only)
  --debloat      Remove bloatware (omarchy only, does nothing on macOS)
  --font         Install fonts from private repo
  -h, --help     Show this help message

Examples:
  $0 --pkg=all                   # Deploy all packages for current OS
  $0 --pkg=ghostty               # Deploy only ghostty package (includes theme linking)
  $0 --pkg=nvim,omarchy          # Deploy multiple packages in order
  $0 --pkg=all --backup          # Deploy all with backup
  $0 --pkg=all --services        # Deploy all, start services
  $0 --services                  # Start systemd services only
  $0 --debloat                   # Remove bloatware (omarchy only)
  $0 --font                      # Install fonts from private repo
EOF
}

# Link nvim theme files
link_nvim_theme() {
    local platform="$1"
    local plugins_dir="$HOME/.config/nvim/lua/plugins"

    mkdir -p "$plugins_dir"

    case "$platform" in
        mac)
            ln -nsf ~/.config/nvim/mac/theme.lua "$plugins_dir/theme.lua"
            ln -nsf ~/.config/nvim/mac/theme-preload.lua "$plugins_dir/omarchy-theme-preload.lua"
            log_success "Neovim theme linked for macOS"
            ;;
        omarchy)
            ln -nsf ~/.config/nvim/omarchy/theme.lua "$plugins_dir/theme.lua"
            ln -nsf ~/.config/nvim/omarchy/theme-preload.lua "$plugins_dir/omarchy-theme-preload.lua"
            log_success "Neovim theme linked for omarchy"
            ;;
        *)
            log_error "Cannot link nvim theme files, unsupported platform: $platform"
            return 1
            ;;
    esac
}

# Remove stow symlinks that still point at the old ~/projects/dots layout
repair_legacy_projects_symlinks() {
    local search_dir link target
    local search_dirs=(
        "$TARGET_DIR/.config"
        "$TARGET_DIR/.local/share/dots"
        "$TARGET_DIR/.zsh"
    )
    local home_links=(
        "$TARGET_DIR/.zprofile"
        "$TARGET_DIR/.zshrc"
        "$TARGET_DIR/.zshenv"
        "$TARGET_DIR/.zsh"
    )

    for link in "${home_links[@]}"; do
        [[ -L "$link" ]] || continue
        target=$(readlink "$link" 2>/dev/null) || continue
        if [[ "$target" == *projects/dots* ]]; then
            log_info "Removing legacy symlink: $link -> $target"
            rm -f "$link"
        fi
    done

    for search_dir in "${search_dirs[@]}"; do
        [[ -d "$search_dir" ]] || continue
        while IFS= read -r -d '' link; do
            target=$(readlink "$link" 2>/dev/null || continue)
            if [[ "$target" == *projects/dots* ]]; then
                log_info "Removing legacy symlink: $link -> $target"
                rm -f "$link"
            fi
        done < <(find "$search_dir" -type l -print0 2>/dev/null)
    done
}

# Remove dotfiles ghostty stow links (Omarchy manages ~/.config/ghostty)
unstow_dots_ghostty() {
    log_info "Skipping ghostty on omarchy (using Omarchy defaults)"
    stow --dir="$STOW_DIR" --target="$TARGET_DIR" -D ghostty 2>/dev/null || true
}

# Link ghostty theme files (macOS only)
link_ghostty_theme() {
    local platform="$1"

    case "$platform" in
        mac)
            ln -nsf ~/.config/ghostty/mac/theme.conf ~/.config/ghostty/theme.conf
            ln -nsf ~/.config/ghostty/mac/settings.conf ~/.config/ghostty/settings.conf
            log_success "Ghostty theme linked for macOS"
            ;;
        *)
            log_error "Cannot link ghostty theme files, unsupported platform: $platform"
            return 1
            ;;
    esac
}

# Link zsh platform files
link_zsh_platform() {
    local platform="$1"
    
    case "$platform" in
        mac)
            ln -nsf ~/.zsh/mac/platform.zsh ~/.zsh/config/platform.zsh
            log_success "Zsh macOS profile linked"
            ;;
        omarchy)
            ln -nsf ~/.zsh/omarchy/platform.zsh ~/.zsh/config/platform.zsh
            log_success "Zsh omarchy configuration ready"
            ;;
        server)
            ln -nsf ~/.zsh/server/platform.zsh ~/.zsh/config/platform.zsh
            log_success "Zsh server configuration ready"
            ;;
        *)
            log_error "Cannot link zsh platform files, unsupported platform: $platform"
            return 1
            ;;
    esac
}

reload_hyprland() {
    hyprctl reload 2>/dev/null && log_success "Hyprland reloaded"
}

apply_cursor_theme() {
    local cursor_theme="BreezeX-Dark"
    local cursor_size="24"

    mkdir -p "$HOME/.icons/default"

    cat > "$HOME/.icons/default/index.theme" << EOF
[Icon Theme]
Inherits=$cursor_theme
EOF

    if [[ -d "$HOME/.icons/$cursor_theme" || -d "/usr/share/icons/$cursor_theme" ]]; then
        hyprctl setcursor "$cursor_theme" "$cursor_size" 2>/dev/null && log_success "Applied cursor theme: $cursor_theme ($cursor_size)" || log_warning "Failed to apply cursor via hyprctl (will apply on next login)"
    else
        log_warning "Cursor theme not found: $cursor_theme"
        log_info "Install it first (setup_omarchy handles this)"
    fi
}

install_breezex_cursor_theme() {
    local cursor_theme="BreezeX-Dark"
    local release_url="https://github.com/ful1e5/BreezeX_Cursor/releases/download/v2.0.1/BreezeX-Dark.tar.xz"
    local tmp_dir="/tmp/breezex-cursor"

    if [[ -d "$HOME/.icons/$cursor_theme" || -d "/usr/share/icons/$cursor_theme" ]]; then
        log_info "Cursor theme already present: $cursor_theme"
        return 0
    fi

    mkdir -p "$HOME/.icons" "$tmp_dir"
    log_info "Installing cursor theme: $cursor_theme"

    wget -qO "$tmp_dir/$cursor_theme.tar.xz" "$release_url"
    tar -xf "$tmp_dir/$cursor_theme.tar.xz" -C "$tmp_dir"

    rm -rf "$HOME/.icons/$cursor_theme"
    mv "$tmp_dir/$cursor_theme" "$HOME/.icons/"
    rm -rf "$tmp_dir"

    log_success "Installed cursor theme: $cursor_theme"
}

setup_mac_theme_sync() {
    if [[ "$PLATFORM" != "mac" ]]; then
        log_info "Theme setup is only needed on macOS"
        return 0
    fi

    local sync_script="$HOME/.local/share/dots/bin/mac-sync-nvim-theme"
    local agent_plist="$HOME/Library/LaunchAgents/com.peterszarvas.theme-sync.plist"
    local launchd_target="gui/$(id -u)"

    mkdir -p "$HOME/.config/omarchy/current/theme"
    mkdir -p "$HOME/Library/LaunchAgents"

    if [[ ! -f "$sync_script" ]]; then
        log_error "Missing theme sync script: $sync_script"
        log_info "Run ./config --pkg=scripts first"
        return 1
    fi

    bash "$sync_script" --apply
    log_success "Initial macOS theme files generated"

    if ! command -v dark-notify >/dev/null 2>&1; then
        log_warning "dark-notify not found. Install it with: brew install cormacrelf/tap/dark-notify"
        return 0
    fi

    if [[ ! -f "$agent_plist" ]]; then
        log_error "Missing launch agent: $agent_plist"
        log_info "Run ./config --pkg=nvim-theme-mac first"
        return 1
    fi

    launchctl bootout "$launchd_target" "$agent_plist" 2>/dev/null || true
    launchctl bootstrap "$launchd_target" "$agent_plist"
    launchctl kickstart -k "$launchd_target/com.peterszarvas.theme-sync"
    log_success "macOS theme watcher loaded"
}

# Start and enable systemd services
start_services() {
    case "$PLATFORM" in
        mac)
            log_info "Starting macOS services..."

            local launchd_target="gui/$(id -u)"
            local agent_plist="$HOME/Library/LaunchAgents/com.peterszarvas.theme-sync.plist"

            if [[ -f "$agent_plist" ]]; then
                launchctl bootout "$launchd_target" "$agent_plist" 2>/dev/null || true
                launchctl bootstrap "$launchd_target" "$agent_plist" && log_success "Loaded launchd agent: com.peterszarvas.theme-sync" || log_warning "Failed to load launchd agent"
                launchctl kickstart -k "$launchd_target/com.peterszarvas.theme-sync" && log_success "Restarted launchd agent: com.peterszarvas.theme-sync" || log_warning "Failed to restart launchd agent"
            else
                log_warning "LaunchAgent not found: $agent_plist (deploy nvim-theme-mac first)"
            fi

            if command -v colima >/dev/null 2>&1; then
                colima start 2>/dev/null && log_success "Colima started" || log_warning "Failed to start Colima"
            else
                log_warning "colima command not found"
            fi
            ;;
        omarchy)
            log_info "Starting and enabling systemd services..."
            
            # List of services to enable/start (add services as needed)
            local services=("colima.service")
            
            for service in "${services[@]}"; do
                if [[ -f "$HOME/.config/systemd/user/$service" ]]; then
                    log_info "Enabling and starting $service"
                    systemctl --user enable "$service" 2>/dev/null && log_success "Enabled $service" || log_warning "Failed to enable $service"
                    systemctl --user start "$service" 2>/dev/null && log_success "Started $service" || log_warning "Failed to start $service"
                    systemctl --user --no-pager status "$service" --lines=3
                else
                    log_warning "Service file not found: $service"
                fi
            done
            ;;
        *)
            log_error "Unsupported platform for service management: $PLATFORM"
            return 1
            ;;
    esac
}

# Remove system bloatware
debloat_system() {
    case "$PLATFORM" in
        mac)
            log_info "Debloat option does nothing on macOS"
            ;;
        omarchy)
            log_info "Removing webapps and packages..."
            
            # Remove webapps
            local webapps=("Basecamp" "Figma" "Google Contacts" "Google Messages" "Zoom")
            for webapp in "${webapps[@]}"; do
                omarchy-webapp-remove "$webapp" 2>/dev/null && log_success "Removed $webapp" || log_warning "$webapp not found"
            done
            
            # Remove packages
            local packages=("obsidian" "spotify" "chromium" "signal-desktop" "alacritty")
            for package in "${packages[@]}"; do
                yay -Rs "$package" --noconfirm 2>/dev/null && log_success "Removed $package" || log_warning "$package not found"
            done
            
            log_success "Debloating completed"
            ;;
        *)
            log_error "Unsupported platform: $PLATFORM"
            return 1
            ;;
    esac
}

# Install fonts from private repo
install_fonts() {
    local private_dir="$HOME/Projects/private"
    
    if [[ ! -d "$private_dir" ]]; then
        log_info "Cloning private font repo..."
        mkdir -p "$(dirname "$private_dir")"
        git clone git@github.com:peterszarvas94/private.git "$private_dir" || { log_error "Failed to clone private repo"; return 1; }
    fi
    
    local font_count=0
    mkdir -p "$HOME/.local/share/fonts"
    
    for font in "$private_dir"/*.ttf "$private_dir"/*.otf; do
        if [[ -f "$font" ]]; then
            cp "$font" "$HOME/.local/share/fonts/" && font_count=$((font_count + 1))
        fi
    done
    
    if [[ $font_count -gt 0 ]]; then
        fc-cache -f 2>/dev/null && log_success "Installed $font_count fonts and refreshed cache" || log_success "Installed $font_count fonts (fc-cache not found)"
    else
        log_info "No font files found in private repo"
    fi
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

# Remove stow symlinks for a package (no-op if not stowed)
unstow_package() {
    local package_name="$1"
    log_info "Unstowing $package_name"
    stow --dir="$STOW_DIR" --target="$TARGET_DIR" -D "$package_name" 2>/dev/null || true
}

# Explicit cleanup before deploying specific packages
cleanup_package() {
    local package_name="$1"

    case "$package_name" in
        alacritty)
            log_info "Removing directory $TARGET_DIR/.config/alacritty"
            rm -rf "$TARGET_DIR/.config/alacritty"
            ;;
        ghostty)
            log_info "Removing directory $TARGET_DIR/.config/ghostty"
            rm -rf "$TARGET_DIR/.config/ghostty"
            ;;
        git)
            log_info "Removing directory $TARGET_DIR/.config/git"
            rm -rf "$TARGET_DIR/.config/git"
            log_info "Removing file $TARGET_DIR/.gitignore"
            rm -f "$TARGET_DIR/.gitignore"
            ;;
        hypr)
            log_info "Removing file $TARGET_DIR/.config/hypr/autostart.conf"
            rm -f "$TARGET_DIR/.config/hypr/autostart.conf"
            log_info "Removing file $TARGET_DIR/.config/hypr/bindings.lua"
            rm -f "$TARGET_DIR/.config/hypr/bindings.lua"
            log_info "Removing file $TARGET_DIR/.config/hypr/envs.conf"
            rm -f "$TARGET_DIR/.config/hypr/envs.conf"
            log_info "Removing file $TARGET_DIR/.config/hypr/hypridle.conf"
            rm -f "$TARGET_DIR/.config/hypr/hypridle.conf"
            log_info "Removing file $TARGET_DIR/.config/hypr/hyprlock.conf"
            rm -f "$TARGET_DIR/.config/hypr/hyprlock.conf"
            log_info "Removing file $TARGET_DIR/.config/hypr/input.lua"
            rm -f "$TARGET_DIR/.config/hypr/input.lua"
            log_info "Removing file $TARGET_DIR/.config/hypr/monitors.conf"
            rm -f "$TARGET_DIR/.config/hypr/monitors.conf"
            ;;
        lazygit)
            log_info "Removing directory $TARGET_DIR/.config/lazygit"
            rm -rf "$TARGET_DIR/.config/lazygit"
            ;;
        herdr)
            local herdr_dir="$TARGET_DIR/.config/herdr"
            local stow_herdr="$STOW_DIR/herdr/.config/herdr"
            if [[ -L "$herdr_dir" ]]; then
                log_info "Migrating herdr from directory symlink to local runtime directory"
                mkdir -p "${herdr_dir}.migrate"
                for f in session.json herdr-client.log herdr-server.log .plugins.lock; do
                    if [[ -e "$stow_herdr/$f" ]]; then
                        mv "$stow_herdr/$f" "${herdr_dir}.migrate/"
                    fi
                done
                for f in "$stow_herdr"/*.sock; do
                    [[ -e "$f" ]] || continue
                    mv "$f" "${herdr_dir}.migrate/" 2>/dev/null || rm -f "$f"
                done
                rm -f "$herdr_dir"
                mv "${herdr_dir}.migrate" "$herdr_dir"
            elif [[ ! -d "$herdr_dir" ]]; then
                mkdir -p "$herdr_dir"
            fi
            for f in session.json herdr-client.log herdr-server.log .plugins.lock; do
                rm -f "$stow_herdr/$f"
            done
            rm -f "$stow_herdr"/*.sock 2>/dev/null || true
            ;;
        nvim)
            unstow_package nvim
            log_info "Removing stow nvim config $TARGET_DIR/.config/nvim"
            rm -rf "$TARGET_DIR/.config/nvim"
            log_info "Removing lazy.nvim data (reinstall on next nvim start)"
            rm -rf "$TARGET_DIR/.local/share/nvim/lazy"
            ;;
        nvim-theme-mac)
            log_info "Removing file $TARGET_DIR/Library/LaunchAgents/com.peterszarvas.theme-sync.plist"
            rm -f "$TARGET_DIR/Library/LaunchAgents/com.peterszarvas.theme-sync.plist"
            ;;
        omarchy)
            # Stow links these as symlinks into the repo — use rm -f, never rm -rf.
            log_info "Removing stow symlink $TARGET_DIR/.config/omarchy/hooks"
            rm -f "$TARGET_DIR/.config/omarchy/hooks"
            log_info "Removing stow symlink $TARGET_DIR/.config/omarchy/branding"
            rm -f "$TARGET_DIR/.config/omarchy/branding"
            log_info "Removing stow symlink $TARGET_DIR/.config/ghostty/config"
            rm -f "$TARGET_DIR/.config/ghostty/config"
            ;;
        opencode)
            log_info "Removing directory $TARGET_DIR/.config/opencode"
            rm -rf "$TARGET_DIR/.config/opencode"
            ;;
        pi)
            log_info "Removing file $TARGET_DIR/.pi/agent/settings.json"
            rm -f "$TARGET_DIR/.pi/agent/settings.json"
            log_info "Removing directory $TARGET_DIR/.pi/agent/themes"
            rm -rf "$TARGET_DIR/.pi/agent/themes"
            log_info "Removing directory $TARGET_DIR/.pi/agent/extensions"
            rm -rf "$TARGET_DIR/.pi/agent/extensions"
            ;;
        scripts)
            unstow_package scripts
            local legacy_bin="$TARGET_DIR/.local/bin"
            if [[ -L "$legacy_bin" ]] && readlink "$legacy_bin" | grep -q 'dots/stow/scripts/.local/bin'; then
                log_info "Replacing legacy scripts symlink: $legacy_bin"
                rm -f "$legacy_bin"
                mkdir -p "$legacy_bin"
            fi
            log_info "Removing stow scripts directory $TARGET_DIR/.local/share/dots/bin"
            rm -rf "$TARGET_DIR/.local/share/dots/bin"
            mkdir -p "$TARGET_DIR/.local/share/dots/bin"
            local script target
            for script in "$STOW_DIR/scripts/.local/share/dots/bin"/*; do
                [[ -e "$script" ]] || continue
                target="$TARGET_DIR/.local/share/dots/bin/$(basename "$script")"
                rm -f "$target"
                rm -f "$TARGET_DIR/.local/bin/$(basename "$script")"
            done
            ;;
        ssh)
            unstow_package ssh
            log_info "Removing stow ssh files under $TARGET_DIR/.ssh"
            rm -f "$TARGET_DIR/.ssh/config"
            rm -f "$TARGET_DIR/.ssh/config.example"
            ;;
        systemd)
            log_info "Removing dotfiles-managed systemd unit: colima.service"
            rm -f "$TARGET_DIR/.config/systemd/user/colima.service"
            ;;
        tmux)
            unstow_package tmux
            log_info "Removing stow tmux config"
            rm -f "$TARGET_DIR/.config/tmux/tmux.conf"
            rm -f "$TARGET_DIR/.tmux.conf"
            ;;
        xdg)
            log_info "Removing file $TARGET_DIR/.config/mimeapps.list"
            rm -f "$TARGET_DIR/.config/mimeapps.list"
            ;;
        zed)
            log_info "Removing directory $TARGET_DIR/.config/zed"
            rm -rf "$TARGET_DIR/.config/zed"
            ;;
        zsh)
            unstow_package zsh
            log_info "Removing stow zsh files ($TARGET_DIR/.zshrc, $TARGET_DIR/.zsh/)"
            rm -f "$TARGET_DIR/.zshrc"
            rm -rf "$TARGET_DIR/.zsh"
            ;;
        *)
            log_info "No explicit cleanup rules for package: $package_name"
            ;;
    esac
}

# Deploy a package by stowing
deploy() {
    local package_name="$1"
    local adopt_flag="${2:-false}"

    if [[ "$PLATFORM" == "omarchy" ]]; then
        case "$package_name" in
            ghostty)
                unstow_dots_ghostty
                return 0
                ;;
        esac
    fi

    if [[ "$package_name" == "ssh" ]]; then
        local ssh_cfg="$STOW_DIR/ssh/.ssh/config"
        local ssh_example="$STOW_DIR/ssh/.ssh/config.example"
        if [[ ! -f "$ssh_cfg" ]]; then
            [[ -f "$ssh_example" ]] || { log_error "Missing $ssh_example"; return 1; }
            log_info "Creating $ssh_cfg from config.example"
            cp "$ssh_example" "$ssh_cfg"
        fi
    fi

    if [[ "$adopt_flag" != true ]]; then
        cleanup_package "$package_name"
    fi
    
    if [[ "$adopt_flag" == true ]]; then
        log_info "Adopting existing files and linking $package_name package"
        stow --dir="$STOW_DIR" --target="$TARGET_DIR" --adopt "$package_name"
        log_success "Adopted and deployed $package_name"
    else
        log_info "Linking $package_name package"
        stow --dir="$STOW_DIR" --target="$TARGET_DIR" "$package_name"
        log_success "Deployed $package_name"
    fi
    
    # Automatically link theme files for specific packages
    case "$package_name" in
        nvim)
            if [[ "$PLATFORM" == "mac" && ! -f "$TARGET_DIR/.local/share/dots/bin/mac-sync-nvim-theme" ]]; then
                log_info "Deploying scripts dependency for macOS theme sync"
                deploy "scripts"
            fi
            link_nvim_theme "$PLATFORM"
            if [[ "$PLATFORM" == "mac" ]]; then
                deploy "nvim-theme-mac"
                setup_mac_theme_sync
            fi
            ;;
        ghostty)
            link_ghostty_theme "$PLATFORM"
            ;;
        zsh)
            link_zsh_platform "$PLATFORM"
            touch "$HOME/.zsh/config/env.zsh"
            ;;
        tmux)
            tmux source-file "$HOME/.config/tmux/tmux.conf" 2>/dev/null || true
            log_success "Tmux config reloaded"
            ;;
        herdr)
            if command -v herdr >/dev/null 2>&1; then
                herdr server reload-config || true
                log_success "Herdr config reloaded"
            else
                log_info "Herdr not installed; skipped config reload"
            fi
            ;;
        hypr)
            install_breezex_cursor_theme
            apply_cursor_theme
            reload_hyprland
            ;;
    esac
}

# Deploy common packages shared across all platforms
deploy_common_packages() {
    log_info "Deploying common packages..."
 
    # Git configuration
    deploy "git"

    # Zsh configuration
    deploy "zsh"
    touch "$HOME/.zsh/config/env.zsh"

    # OpenCode configuration
    deploy "opencode"

    # Pi configuration
    deploy "pi"

    # Scripts
    deploy "scripts"

    # Neovim configuration
    deploy "nvim"

    # Tmux configuration
    deploy "tmux"

    # Herdr configuration
    deploy "herdr"
}

# Deploy platform-specific packages for Arch Linux (omarchy)
deploy_omarchy_packages() {
    log_info "Deploying Arch Linux (omarchy) specific packages..."

    unstow_dots_ghostty

    # Hyprland window manager
    deploy "hypr"

    # Omarchy
    deploy "omarchy"

    # Systemd user units from dotfiles (colima.service only)
    deploy "systemd"

    # XDG defaults
    deploy "xdg"
}

deploy_mac_packages() {
    log_info "Deploying macOS specific packages..."

    deploy "ghostty"
}

# Main deployment function
deploy_dotfiles() {
    log_info "Starting dotfiles deployment for platform: $PLATFORM"

    repair_legacy_projects_symlinks

    # If specific packages are requested (without "all"), deploy only those.
    if [[ ${#PKGS[@]} -gt 0 ]]; then
        local pkg
        local has_all=false
        for pkg in "${PKGS[@]}"; do
            if [[ "$pkg" == "all" ]]; then
                has_all=true
                break
            fi
        done

        if [[ "$has_all" == false ]]; then
            for pkg in "${PKGS[@]}"; do
                deploy "$pkg" false
            done
            log_success "Package list deployed successfully: ${PKGS[*]}"
            return 0
        fi
    fi
    
    # Deploy platform-specific packages
    case "$PLATFORM" in
        mac)
            deploy_common_packages
            deploy_mac_packages
            ;;
        omarchy)
            deploy_common_packages
            deploy_omarchy_packages
            ;;
        server)
            deploy_common_packages
            deploy "ghostty"
            ;;
        *)
            log_error "Unknown platform: $PLATFORM"
            return 1
            ;;
    esac
    
    log_success "Dotfiles deployment completed successfully!"

}

# Detect platform automatically
detect_platform() {
    case "$(uname)" in
        Darwin)
            echo "mac"
            ;;
        Linux)
            if command -v omarchy &>/dev/null || [[ -d "${HOME}/.local/share/omarchy" ]]; then
                echo "omarchy"
            else
                echo "server"
            fi
            ;;
        *)
            log_error "Unsupported operating system: $(uname)"
            exit 1
            ;;
    esac
}

# Validate package name exists
validate_package() {
    local pkg_name="$1"
    
    # Allow "all" as a special case
    if [[ "$pkg_name" == "all" ]]; then
        return 0
    fi
    
    # Check if package directory exists in stow directory
    if [[ ! -d "$STOW_DIR/$pkg_name" ]]; then
        log_error "Package '$pkg_name' not found in stow directory"
        log_info "Available packages:"
        ls -1 "$STOW_DIR" | sed 's/^/  /'
        return 1
    fi
}

# Parse command line arguments
parse_arguments() {
    PLATFORM=$(detect_platform)
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --pkg=*)
                local pkg_arg="${1#*=}"
                if [[ -z "$pkg_arg" ]]; then
                    log_error "Empty --pkg value"
                    exit 1
                fi
                local IFS=','
                local pkg
                for pkg in $pkg_arg; do
                    if [[ -z "$pkg" ]]; then
                        continue
                    fi
                    validate_package "$pkg" || exit 1
                    PKGS+=("$pkg")
                done
                shift
                ;;
            --backup)
                BACKUP_MODE=true
                shift
                ;;
            --font)
                WITH_FONT=true
                shift
                ;;
            --services)
                WITH_SERVICES=true
                shift
                ;;
            --debloat)
                WITH_DEBLOAT=true
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
    

    
    if [[ "$BACKUP_MODE" == true ]]; then
        log_info "Backup mode enabled - existing configs will be backed up"
    fi
    
    # Check if any action is requested
    if [[ ${#PKGS[@]} -eq 0 && "$WITH_FONT" == false && "$WITH_SERVICES" == false && "$WITH_DEBLOAT" == false ]]; then
        log_info "Nothing to do. Use --pkg=all, --font, --services, or --debloat to specify actions."
        exit 0
    fi

    if [[ ${#PKGS[@]} -gt 0 ]]; then
        deploy_dotfiles
    fi

    if [[ "$WITH_FONT" == true ]]; then
        install_fonts
    fi

    if [[ "$WITH_SERVICES" == true ]]; then
        start_services
    fi
    
    if [[ "$WITH_DEBLOAT" == true ]]; then
        debloat_system
    fi

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
