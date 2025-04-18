#!/bin/bash

# Color definition
NO_FORMAT="\033[0m"
F_BOLD="\033[1m"
F_UNDERLINED="\033[4m"
C_CORNFLOWERBLUE="\033[38;5;69m"
echo -e "${F_BOLD}${F_UNDERLINED}${C_CORNFLOWERBLUE}Auto update config files... - Arch linux${NO_FORMAT}"

# Controlated exit
ctrl_c() {
  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [!] Leaving...${NO_FORMAT} \n"
  exit 1
}

# Ctrol + C
trap ctrl_c INT

update_terminal_emulator_config() {
  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Copying terminal emulator config ~ Ghostty. ${NO_FORMAT} \n"

  rm -r TerminalEmulators/Ghostty/*

  cp -r ~/.config/ghostty/* TerminalEmulators/Ghostty
}

update_shell_config() {
  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Copying shell config ~ Zsh with powerlevel10k. ${NO_FORMAT} \n"

  rm -r Shells/Zsh/*

  cp ~/.zshrc Shells/Zsh/
  cp ~/.p10k.zsh Shells/Zsh/
}

update_window_manager_config() {
  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Copying window manager config ~ Hyprland. ${NO_FORMAT} \n"

  rm -r Hyprland/*
  rm -r zprofile/*

  cp -r ~/.zprofile zprofile/
  cp -r ~/.config/hypr/* Hyprland/
}

update_nvim_config() {
  echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Copying nvim config. ${NO_FORMAT} \n"

  rm -r Nvim/*

  cp -r ~/.config/nvim/* Nvim/
}

update_collection() {
  update_nvim_config
  update_window_manager_config
  update_terminal_emulator_config
  update_shell_config
}

#
#Main flow:
#

update_collection

echo -e "${F_BOLD}${C_CORNFLOWERBLUE}\n\n [+] Configuration updated.${NO_FORMAT} \n"
