# Dotfiles

## Set up Mac:

Install Homebrew:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install wget:

```bash
brew install wget
```

Run setup script:

```bash
wget -qO- "https://raw.githubusercontent.com/peterszarvas94/dots/master/setup_mac?$(date +%s)" | bash
```

## Set up Omarchy:

`yay` is already installed, we need `wget`

```bash
yay -S --noconfirm --needed wget
```

```bash
wget -qO- "https://raw.githubusercontent.com/peterszarvas94/dots/master/setup_omarchy?$(date +%s)" | bash
```

## Scripts

### ESM Package Downloader

A utility script to download JavaScript packages from esm.sh CDN.

**Usage:**
```bash
esm package [options]
```

**Examples:**
```bash
# Download latest version (non-minified by default)
esm react -d components

# Download specific version
esm pocketbase -v 0.26.3 -d scripts

# Download minified version
esm lodash --minify --version 4.17.21 --dir lib

# Short flags
esm react -m -v 18.3.1 -d components
```

**Options:**
- `-v, --version VER` - Package version (default: latest)
- `-d, --dir DIR` - Download to specified directory (default: current directory)
- `-m, --minify` - Download minified version (default: non-minified)
- `-h, --help` - Show help message

The script downloads non-minified, readable code by default. Use `-m` or `--minify` only when you need the compressed version.

## TODO

- hyprland stuff
- git ssh keys script
- `git remote remove origin`
- `git remote add origin git@github.com:peterszarvas94/dots.git`
- add other missing packages (opencode, ruby etc)
