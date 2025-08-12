{ config, pkgs, system, ... }: let
  home = if builtins.match ".*-darwin" builtins.currentSystem != null then "/Users/samuel" else "/home/samuel";
in {
  home.username = "samuel";
  home.homeDirectory = home;

  home.packages = with pkgs; [
    fzf pstree

    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.file = {
    ".bash_profile".text = ''
      export HISTSIZE=5000 HISTCONTROL=ignoreboth:erasedups HISTFILE=~/.bash_history PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"
      shopt -s histappend

      export EDITOR=vi
      set -o vi

      source <(fzf --bash)
    '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/samuel/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    #EDITOR = "vi";
  };

  programs.home-manager.enable = true;
  programs.tmux = {
    enable = true;
    extraConfig = ''
      unbind C-b
      set -g prefix `
      bind ` send-prefix
      #set-window-option -g mode-keys vi
      set -w -g mode-keys vi
      set -g status off
      set -g mouse on
      #set -g default-shell /opt/homebrew/bin/fish
      new-session
    '';
  };
  programs.git = {
    enable = true;
    userName = "Samuel Shan";
    userEmail = "samuel.shan@gmail.com";
  };
  programs.vim = {
    enable = true;
    extraConfig = ''
      set ai ts=2 sw=2 et
      set is
      syntax on
    '';
  };

  home.stateVersion = "25.05";
}
