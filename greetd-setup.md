# Greetd + Regreet Setup

Steps to replace autologin with greetd display manager:

## 1. Install packages
```bash
sudo pacman -S greetd greetd-regreet
```

## 2. Disable autologin
```bash
# Move override file to backup
sudo mv /etc/systemd/system/getty@tty1.service.d/override.conf /etc/systemd/system/getty@tty1.service.d/override.conf.bak
sudo systemctl daemon-reload
```

## 3. Comment out Hyperland autostart
Edit `~/.zprofile` and comment out:
```bash
# [[ -z $DISPLAY && $(tty) == /dev/tty1 ]] && exec Hyprland
```

## 4. Configure greetd
Edit `/etc/greetd/config.toml` to use regreet as greeter.

## 5. Enable greetd service
```bash
sudo systemctl enable greetd.service
```

## 6. Reboot to test

## Rollback steps (if needed)
```bash
# Restore autologin
sudo mv /etc/systemd/system/getty@tty1.service.d/override.conf.bak /etc/systemd/system/getty@tty1.service.d/override.conf
sudo systemctl daemon-reload

# Uncomment Hyperland autostart in ~/.zprofile
# Disable greetd
sudo systemctl disable greetd.service
```