# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
source $HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source $HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# use showkey -a for help you find keys

# Key bindings
forward-kill-word() {
zle kill-word 
}
zle -N forward-kill-word

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey "^H" backward-kill-word
bindkey '^[[3;5~' forward-kill-word
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
