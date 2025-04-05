#!/bin/bash

set -e

rm -rf ~/.config/nvim

rm -rf ~/.local/share/nvim

# Define colors for output using tput for better compatibility
PURPLE=$(tput setaf 141)
GREEN=$(tput setaf 114)
YELLOW=$(tput setaf 221)
NC=$(tput sgr0) # No Color

echo -e "${PURPLE}Mati Pou Arch Env. - Auto Config!${NC}"

sudo -v

while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

install_starter_packages() {
  echo -e "${YELLOW}Installing starter packages...${NC}"

  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed --noconfirm base-devel curl file wget ruby-erb nano

  # Yay install
  sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

  yay -Y --gendb
  yay -Y --devel --save

  # Homebrew install
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.bashrc
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
  brew install gcc
}

install_apps() {
  wmpackages=(
    hyprland
    waybar
    pavucontrol
    uwsm
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    wl-clipboard
    sddm
  )

  echo "Installing hyprland packages"
  sudo pacman -Syu --needed --noconfirm "${wmpackages[@]}"

  yay -S ags-hyprpanel-git
  sudo pacman -S --needed wireplumber libgtop bluez bluez-utils btop networkmanager dart-sass wl-clipboard brightnessctl swww python upower pacman-contrib power-profiles-daemon gvfs wf-recorder

  appsPackages=(
    ghostty
    firefox
    obsidian
    spotify-launcher
    obs-studio
    rofi
    bat
  )

  echo "Installing app packages"
  sudo pacman -S --needed --noconfirm "${appsPackages[@]}"

  toolsPackages=(
    lsd
    fzf
  )

  echo "Installing app packages"
  sudo brew install "${toolsPackages[@]}"

}

install_starter_packages

install_apps

# Step 1: Clone the Repository
echo -e "${YELLOW}Step 1: Clone the Repository${NC}"

if [ -d "personal.env.dots" ]; then
  echo -e "${GREEN}Repository already cloned. Overwriting...${NC}"
  rm -rf "personal.env.dots"
fi

git clone "https://github.com/matipou/personal.env.dots.git" "personal.env.dots"

cd personal.env.dots || exit

# Function to install a terminal emulator with progress
echo -e "${YELLOW}Installing and configuring terminal emulator...${NC}"

if ! command -v ghostty &>/dev/null; then
  pacman -S ghostty
  mkdir -p ~/.config/ghostty && cp -r TerminalEmulators/Ghostty/* ~/.config/ghostty
fi

echo -e "${YELLOW}Installing Iosevka Term Nerd Font...${NC}"
mkdir -p ~/.local/share/fonts
wget -O ~/.local/share/fonts/IosevkaTerm.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/IosevkaTerm.zip
unzip ~/.local/share/fonts/IosevkaTerm.zip -d ~/.local/share/fonts/
fc-cache -fv
echo -e "${GREEN}Iosevka Term Nerd Font installed.${NC}"

set_as_default_shell() {
  command -v zsh | sudo tee -a /etc/shells
  sudo chsh -s $(which zsh) $USER
}

# installing zsh
brew install zsh carapace zoxide atuin

brew install zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete

echo -e "${YELLOW}Configuring Zsh...${NC}"

mkdir -p ~/.cache/carapace
mkdir -p ~/.local/share/atuin

cp -rf Shells/Zsh/.zshrc ~/
cp -rf Shells/Zsh/.p10k.zsh ~/

# PowerLevel10K Configuration
echo -e "${YELLOW}Configuring PowerLevel10K...${NC}"
brew install powerlevel10k

# Step 5: Additional Configurations
echo -e "${YELLOW}Step 4: Configuring Hyprland${NC}"
cp -rf zprofile/.zprofile ~/
cp -rf Hyprland/* ~/config/hypr

# Neovim Configuration
echo -e "${YELLOW}Step 5: Installing NVIM${NC}"

# Install additional packages with Neovim
brew install nvim node npm git gcc fd ripgrep coreutils bat curl lazygit

# Neovim Configuration
echo -e "${YELLOW}Configuring Neovim...${NC}"
mkdir -p ~/.config/nvim
cp -r Nvim/* ~/.config/nvim/

# Clean up: Remove the cloned repository
chown -R $(whoami) $(brew --prefix)/*
echo -e "${YELLOW}Cleaning up...${NC}"
cd ..
rm -rf personal.env.dots

set_as_default_shell

echo -e "${GREEN}Configuration complete. Please restart shell...${NC}"
