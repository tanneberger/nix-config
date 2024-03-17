{ pkgs, config, lib, ... }:
with pkgs;
let
  /*nerdtree = fetchurl {
    url = "https://github.com/tanneberger/nix-config/dotfiles/raw/branch/master/config/nvim/plugins/nerdtree.vim";
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
	*/
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

        " Set completeopt to have a better completion experience
        " :help completeopt
        " menuone: popup even when there's only one match
        " noinsert: Do not insert text until a selection is made
        " noselect: Do not select, force user to select one from the menu
        set completeopt=menuone,noinsert,noselect

        " Avoid showing extra messages when using completion
        set shortmess+=c

        " Configure LSP through rust-tools.nvim plugin.
        " rust-tools will configure and enable certain LSP features for us.
        " See https://github.com/simrat39/rust-tools.nvim#configuration
        lua <<EOF

        -- nvim_lsp object
        local nvim_lsp = require'lspconfig'

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

        local opts = {
            tools = {
                runnables = {
                    use_telescope = true
                },
                inlay_hints = {
                    auto = true,
                    show_parameter_hints = true,
                },
            },

            -- all the opts to send to nvim-lspconfig
            -- these override the defaults set by rust-tools.nvim
            -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
            server = {
                -- on_attach is a callback called when the language server attachs to the buffer
                -- on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    -- to enable rust-analyzer settings visit:
                    -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                    ["rust-analyzer"] = {
                        -- enable clippy on save
                        checkOnSave = {
                            command = "clippy"
                        },
                        inlayHints = {
                          maxLength = nil,
                          closureReturnTypeHints = true,
                          reborrowHints = true,
                          lifetimeElisionHints = {
                              enable = "skip_trivial", -- never, skip_trivial, always
                              useParameterNames = true,
                          }
                       }
                    }
                }
            },
        }

        require('rust-tools').setup(opts)
        EOF

        " Code navigation shortcuts
        " as found in :help lsp
        nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
        nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
        nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
        nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
        nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
        nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
        nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
        nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
        nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>

        " Quick-fix
        nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>

        " Setup Completion
        " See https://github.com/hrsh7th/nvim-cmp#basic-configuration
        lua <<EOF
        local cmp = require'cmp'
        cmp.setup({
          snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end,
          },
          mapping = {
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            -- Add tab support
            ['<S-Tab>'] = cmp.mapping.select_prev_item(),
            ['<Tab>'] = cmp.mapping.select_next_item(),
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            })
          },

          -- Installed sources
          sources = {
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
            { name = 'path' },
            { name = 'buffer' },
          },
        })
        EOF

        " have a fixed column for the diagnostics to appear in
        " this removes the jitter when warnings/errors flow in
        set signcolumn=yes

        " Set updatetime for CursorHold
        " 300ms of no cursor movement to trigger CursorHold
        set updatetime=300
        " Show diagnostic popup on cursor hover
        autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
        " Goto previous/next diagnostic warning/error
        nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev()<CR>
        nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next()<CR>

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
        telescope-nvim # Fuzzy Findernvim
        plenary-nvim # Dependency of telescope
        glow-nvim # Markdown commandline renderer
        vimtex
        #YouCompleteMe # premium auto completion
        vim-clang-format # autoformatting with clang
        syntastic # Syntax checking
        vim-move # moving selected block in file
        lingua-franca-vim # syntax highlighting for lingua franca
        vimPlugins.kotlin-vim # syntax for kotlin
        rust-tools-nvim
        nvim-cmp # auto completion
        nvim-lspconfig
        cmp-nvim-lsp
        cmp-vsnip
        cmp-path
        cmp-buffer
        vim-vsnip

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
