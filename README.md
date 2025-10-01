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

## TODO

- hyprland stuff
- proper git auto setup (ssh keys)
- add other missing packages (opencode, ruby etc)
