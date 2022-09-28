{ pkgs, config, lib, ... }:
with pkgs;
let
  nerdtree = fetchurl {
    url = "https://gitea.tassilo-tanneberger.de/revol-xut/dotfiles/raw/branch/master/config/nvim/plugins/nerdtree.vim";
    sha256 = "sha256-Xq0g2Q6pwKcFtnCieLPx8RLzZ0+93QQgYVEvsUQ8nj8=";
  };
  telescope = fetchurl {
    url = "https://gitea.tassilo-tanneberger.de/revol-xut/dotfiles/raw/branch/master/config/nvim/plugins/telescope.vim";
    sha256 = "sha256-1B1M7Acyj2Fxe8FpYc68FiDuXSnOm1UhyG4Al14vL/w=";
  };
  syntastic = fetchurl {
    url = "https://gitea.tassilo-tanneberger.de/revol-xut/dotfiles/raw/branch/master/config/nvim/plugins/syntastic.vim";
    sha256 = "sha256-tgjofEa/WJsSuQtZj2QMACqQzN2K95AR9O9G+GeqHi0=";
  };

in
{
  # Overlay to use the master build
  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      #coc = {
      #  enable = true;
      #};

      extraConfig = ''
        colorscheme dracula
        " delek
        set mouse=a

        "configuration of some plugins
        source ${telescope}
        source ${syntastic}

        " Relativ Line Numbers
        set tabstop=4 shiftwidth=4 expandtab
        set list                        " show Whitespaces
        set listchars=tab:\ \ ,trail:·  " show tabs as tabs and trailing spaces as dots
        set relativenumber
        ":au BufAdd,BufNewFile,BufRead * nested tab sball
        set splitbelow

        set viminfo+=n~/.vim/viminfo

        nnoremap <Leader>F :<C-u>ClangFormat<CR>
        let g:move_key_modifier = 'C'
        
        :function Nixbuild()
        :   v:lua.os.execute("/run/current-system/sw/bin/nix-build .")
        :endfunction

        "lua << EOF
        "  function! nix-build() {
        "    os.execute("nix-build")
        "  }
        "
        "  function! nix-build() {
        "    print(os.execute("pwd && ls -la"))
        "  }
        "  EOF

      '';

      extraPackages = with pkgs; [
        tree-sitter
        nodePackages.typescript
        nodePackages.typescript-language-server
        gopls
        nodePackages.pyright
        rust-analyzer
        #nodePackages.coc-rust-analyzer
      ];
      plugins = with pkgs.vimPlugins; [
        rust-vim
        vim-which-key
        vim-nix
        dracula-vim # dracula colorschema
        palenight-vim # Colorscheme
        nerdtree # File Explorer
        vim-easy-align # Algining code
        lightline-vim
        vim-quickrun
        tagbar # Fancy Bar
        telescope-nvim # Fuzzy Finder
        plenary-nvim # Dependency of telescope
        glow-nvim # Markdown commandline renderer
        vimtex
        YouCompleteMe # premium auto completion
        vim-clang-format # autoformatting with clang
        syntastic # Syntax checking
        vim-move # moving selected block in file
        lingua-franca-vim # syntax highlighting for lingua franca
        vimPlugins.kotlin-vim # syntax for kotlin
        rust-tools-nvim
        #auto-pairs # auto pairing stuff like ( or "
        #coc-vimtex
        #coc-python
        #coc-rust-analyzer
        #coc-spell-checker
        #coc-git
        #coc-stylelint

      ];
    };
  };
}
