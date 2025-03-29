#!/bin/bash

set -e

rm -rf ~/.config/nvim

rm -rf ~/.local/share/nvim

# Define colors for output using tput for better compatibility
PINK=$(tput setaf 204)
PURPLE=$(tput setaf 141)
GREEN=$(tput setaf 114)
ORANGE=$(tput setaf 208)
BLUE=$(tput setaf 75)
YELLOW=$(tput setaf 221)
RED=$(tput setaf 196)
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
  git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

  # Homebrew install
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  . $HOME/.cargo/env

  echo >>~/.bashrc
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.bashrc
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  brew install gcc
}

install_apps() {
  gdmpackages=(
    gdm
    gnome-calculator
    nautilus
    gnome-menus
    gnome-control-center
    gnome-session
    xdg-desktop-portal-gnome
    xdg-desktop-portal
  )

  echo "Installing gnome display manager packages"
  sudo pacman -S --needed --noconfirm "${gdmpackages[@]}"
  sudo systemctl enable gdm.service

  appsPackages=(
    ghostty
    firefox
    obsidian
    spotify
    obs-studio
    rofi
  )

  echo "Installing app packages"
  sudo pacman -S --needed --noconfirm "${appsPackages[@]}"
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

cd personal.evn.dots || exit

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

echo -e "${YELLOW}Step 4: Installing Zellij Window Manager${NC}"

# Neovim Configuration
echo -e "${YELLOW}Step 5: Installing NVIM${NC}"

# Install additional packages with Neovim
brew install nvim node npm git gcc fzf fd ripgrep coreutils bat curl lazygit

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
