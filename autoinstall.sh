#!/bin/bash
set -e

# Color definition
NO_FORMAT="\033[0m"
F_BOLD="\033[1m"
F_UNDERLINED="\033[4m"
C_CORNFLOWERBLUE="\033[38;5;69m"
echo -e "${F_BOLD}${F_UNDERLINED}${C_CORNFLOWERBLUE}Auto environment instalation starting... - Arch linux${NO_FORMAT}"

# Controlated exit
ctrl_c() {
  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [!] Leaving...${NO_FORMAT} \n"
  exit 1
}

# Ctrol + C
trap ctrl_c INT

install_dependecies_packages() {
  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Instaling dependencies. ${NO_FORMAT} \n"

  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed --noconfirm base-devel curl file wget ruby-erb nano git
}

install_packages_managers() {
  # Yay install
  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Instaling yay packages manager. ${NO_FORMAT} \n"
  git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

  yay -Y --gendb
  yay -Y --devel --save

  # Homebrew install
  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Instaling Homebrew packages manager. ${NO_FORMAT} \n"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  . $HOME/.cargo/env

  echo >>~/.bashrc
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.bashrc
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  brew install gcc
}

install_windows_manager_packages() {
  pacmanPackages=(
    hyprland
    waybar
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  )

  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Installing windows manager packages ~ Hyperland ${NO_FORMAT} \n"
  sudo pacman -Syu --needed --noconfirm "${pacmanPackages[@]}"
}

install_system_utilities_packages() {
  pacmanPackages=(
    pavucontrol
    uwsm
    wl-clipboard
    sddm
    blueman
    bluez
    bluez-utils
    duf
    wireplumber
    libgtop
    networkmanager
  )

  aurPackages=(
    grim
    slurp
  )

  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Installing system utilities packages${NO_FORMAT} \n"

  sudo pacman -Syu --needed --noconfirm "${pacmanPackages[@]}"

  yay "${aurPackages[@]}"
}

enable_system_services() {
  sudo systemctl enable bluetooth.service
}

install_apps_packages() {
  pacmanPackages=(
    ghostty
    firefox
    obsidian
    obs-studio
  )

  brewPackages=(
    zsh
    carapace
    zoxide
    atuin
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-autocomplete
    powerlevel10k
    nvim
    node
    npm
    gcc
    fd
    ripgrep
    coreutils
    lazygit
  )

  aurPackages=(
    tidal-hifi-bin-5.18.2-1
  )

  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Installing apps packages${NO_FORMAT} \n"

  sudo pacman -Syu --needed --noconfirm "${pacmanPackages[@]}"

  yay "${aurPackages[@]}"

  brew install "${brewPackages[@]}"
}

install_tools_packages() {
  pacmanPackages=(
    rofi
    bat
  )

  brewPackages=(
    lsd
    fzf
  )

  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Installing tools packages${NO_FORMAT} \n"

  sudo pacman -Syu --needed --noconfirm "${pacmanPackages[@]}"

  brew install "${brewPackages[@]}"
}

install_packages() {
  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Installing packages${NO_FORMAT} \n"

  install_dependecies_packages
  install_packages_managers
  install_system_utilities_packages
  enable_system_services
  install_windows_manager_packages
  install_apps_packages
  install_tools_packages
}

remove_old_config_files() {
  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Removing old config files. ${NO_FORMAT} \n"

  rm -rf ~/.config/nvim
  rm -rf ~/.local/share/nvim
}

clone_dotfiles_repository() {
  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Cloning dot files repository ... ${NO_FORMAT} \n"

  if [ -d "personal.env.dots" ]; then
    rm -rf "personal.env.dots"
  fi

  git clone "https://github.com/matipou/personal.env.dots.git" "personal.env.dots"

  cd personal.env.dots || exit
}

config_terminal_emulator() {
  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Configuring terminal emulator ~ Ghostty ${NO_FORMAT} \n"
  mkdir -p ~/.config/ghostty && cp -r TerminalEmulators/Ghostty/* ~/.config/ghostty
}

config_font() {
  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Installing Iosevka Term Nerd Font ${NO_FORMAT} \n"
  mkdir -p ~/.local/share/fonts
  wget -O ~/.local/share/fonts/IosevkaTerm.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/IosevkaTerm.zip
  unzip ~/.local/share/fonts/IosevkaTerm.zip -d ~/.local/share/fonts/
  fc-cache -fv
}

config_shell() {
  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Configuring shell ~ zsh ${NO_FORMAT} \n"
  mkdir -p ~/.cache/carapace
  mkdir -p ~/.local/share/atuin

  cp -rf Shells/Zsh/.zshrc ~/
  cp -rf Shells/Zsh/.p10k.zsh ~/

  chown -R $(whoami) $(brew --prefix)/*
}

set_as_default_shell() {
  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Setting zsh as default shell ${NO_FORMAT} \n"
  command -v zsh | sudo tee -a /etc/shells
  sudo chsh -s $(which zsh) $USER
}

config_windows_manager() {
  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Configuring window manager ~ Hyprland ${NO_FORMAT} \n"
  cp -rf zprofile/.zprofile ~/
  cp -rf Hyprland/* ~/config/hypr
}

config_nvim() {
  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Configuring NVIM ${NO_FORMAT} \n"
  mkdir -p ~/.config/nvim
  cp -r Nvim/* ~/.config/nvim/
}

remove_cloned_repository() {
  echo -e "${YELLOW}Cleaning up...${NC}"
  cd ..
  rm -rf personal.env.dots
}

install_cursor_theme() {

  USER_DIR="$HOME/.local/share/icons"

  if [ -d "$USER_DIR/Vimix-cursors" ]; then
    rm -rf "$USER_DIR/Vimix-cursors"
  fi

  if [ -d "$USER_DIR/Vimix-white-cursors" ]; then
    rm -rf "$USER_DIR/Vimix-white-cursors"
  fi

  cp -r CursorTheme/DarkTheme/ "$USER_DIR"/Vimix-cursors
  cp -r CursorTheme/WhiteTheme/ "$USER_DIR"/Vimix-white-cursors
}

load_configs() {
  remove_old_config_files
  clone_dotfiles_repository
  config_windows_manager
  config_terminal_emulator
  config_font
  config_shell
  config_nvim
  remove_cloned_repository
  install_cursor_theme
}

#
#Main flow:
#

install_packages

load_configs

echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Configuration complete. Please reboot system...${NO_FORMAT} \n"
