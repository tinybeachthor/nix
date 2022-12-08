{ pkgs, ... }:

{
  enable = true;

  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;

  withRuby = true;
  withPython3 = true;
  withNodeJs = true;

  extraConfig = builtins.readFile ./neovim.vim;

  extraPackages = with pkgs; [
    git

    fzf
    ripgrep
    bat
    delta
  ];

  plugins =
    with pkgs;
    with pkgs.vimPlugins; [
      # core
      { plugin = vim-commentary; }
      { plugin = vim-unimpaired; }
      { plugin = vim-surround; }
      { plugin = vim-repeat; }
      { plugin = ferret;
        config = ''
          let mapleader = "\<space>"

          nnoremap <leader><S-a> :<C-u>Back<space>
        '';
      }
      { plugin = vim-trailing-whitespace; }
      { plugin = vim-abolish; }

      { plugin = nvim-treesitter.withAllGrammars; }
      { plugin = coq_nvim;
        config = ''
          let g:coq_settings = { 'xdg': v:true }
        '';
      }
      { plugin = nvim-lspconfig;
        config = ''
          lua << EOF

          local lsp = require'lspconfig'
          local coq = require "coq"

          local on_attach = function(client, bufnr)
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            local bufopts = { noremap=true, silent=true, buffer=bufnr }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
            vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
            vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
          end

          lsp.rust_analyzer.setup(coq.lsp_ensure_capabilities({
            on_attach=on_attach,
            settings = {
              ["rust-analyzer"] = {
                imports = {
                  granularity = {
                    group = "module",
                  },
                  prefix = "self",
                },
                cargo = {
                  buildScripts = {
                    enable = true,
                  },
                },
                procMacro = {
                  enable = true
                },
              }
            }
          }))
          lsp.tsserver.setup(coq.lsp_ensure_capabilities({
            on_attach=on_attach
          }))

          EOF
        '';
      }

      # files
      { plugin = fzf-vim;
        config = ''
          let mapleader = "\<space>"

          nnoremap <leader><leader> :GFiles<CR>
          autocmd StdinReadPre * let s:std_in=1
          autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | call fzf#run({'sink': 'e'}) | endif

          " An action can be a reference to a function that processes selected lines
          function! s:load_quickfix_list(lines)
              call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
              copen
              cc
          endfunction

          let g:fzf_action = {
            \ 'ctrl-l': function('s:load_quickfix_list'),
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-s': 'split',
            \ 'ctrl-v': 'vsplit' }
        '';
      }
      { plugin = vim-eunuch;
        config = ''
          let g:netrw_preview   = 1
          let g:netrw_liststyle = 2
          let g:netrw_winsize   = 20
          let g:netrw_banner    = 0
          let g:netrw_altv      = 1
          let g:netrw_list_hide = netrw_gitignore#Hide() . '.*\.swp$,.*\.un\~$,.git/$'
        '';
      }
      { plugin = vim-vinegar; }

      # git
      { plugin = vim-fugitive; }
      { plugin = vim-gitgutter;
        config = ''
          let g:gitgutter_override_sign_column_highlight = 0
          let g:SignatureMarkerTextHLDynamic = 1
        '';
      }

      # look
      { plugin = vim-airline;
        config = ''
          let mapleader = "\<space>"

          set noshowmode " Hide mode indicator - included in airline
          let g:airline#extensions#tabline#enabled = 1
          let g:airline#extensions#tabline#buffer_idx_mode = 1
          let g:airline#parts#ffenc#skip_expected_string = 'utf-8[unix]'
          let g:airline_section_z = '%3p%% %3l/%L:%3v'

          nmap <silent> <leader>1 <Plug>AirlineSelectTab1
          nmap <silent> <leader>2 <Plug>AirlineSelectTab2
          nmap <silent> <leader>3 <Plug>AirlineSelectTab3
          nmap <silent> <leader>4 <Plug>AirlineSelectTab4
          nmap <silent> <leader>5 <Plug>AirlineSelectTab5
          nmap <silent> <leader>6 <Plug>AirlineSelectTab6
          nmap <silent> <leader>7 <Plug>AirlineSelectTab7
          nmap <silent> <leader>8 <Plug>AirlineSelectTab8
          nmap <silent> <leader>9 <Plug>AirlineSelectTab9
          nmap <silent> <leader>0 <Plug>AirlineSelectTab10

          " switch to last buffer
          nnoremap <silent> <Leader>- :b#<CR>

          nmap <silent> <leader>v1 <C-w><C-v><Plug>AirlineSelectTab1
          nmap <silent> <leader>v2 <C-w><C-v><Plug>AirlineSelectTab2
          nmap <silent> <leader>v3 <C-w><C-v><Plug>AirlineSelectTab3
          nmap <silent> <leader>v4 <C-w><C-v><Plug>AirlineSelectTab4
          nmap <silent> <leader>v5 <C-w><C-v><Plug>AirlineSelectTab5
          nmap <silent> <leader>v6 <C-w><C-v><Plug>AirlineSelectTab6
          nmap <silent> <leader>v7 <C-w><C-v><Plug>AirlineSelectTab7
          nmap <silent> <leader>v8 <C-w><C-v><Plug>AirlineSelectTab8
          nmap <silent> <leader>v9 <C-w><C-v><Plug>AirlineSelectTab9
          nmap <silent> <leader>v0 <C-w><C-v><Plug>AirlineSelectTab10

          nmap <silent> <leader>s1 <C-w><C-s><Plug>AirlineSelectTab1
          nmap <silent> <leader>s2 <C-w><C-s><Plug>AirlineSelectTab2
          nmap <silent> <leader>s3 <C-w><C-s><Plug>AirlineSelectTab3
          nmap <silent> <leader>s4 <C-w><C-s><Plug>AirlineSelectTab4
          nmap <silent> <leader>s5 <C-w><C-s><Plug>AirlineSelectTab5
          nmap <silent> <leader>s6 <C-w><C-s><Plug>AirlineSelectTab6
          nmap <silent> <leader>s7 <C-w><C-s><Plug>AirlineSelectTab7
          nmap <silent> <leader>s8 <C-w><C-s><Plug>AirlineSelectTab8
          nmap <silent> <leader>s9 <C-w><C-s><Plug>AirlineSelectTab9
          nmap <silent> <leader>s0 <C-w><C-s><Plug>AirlineSelectTab10

          " split with last buffer
          nnoremap <silent> <Leader>v- :vsplit<CR>:b#<CR>
          nnoremap <silent> <Leader>s- :split<CR>:b#<CR>

          " coc integration
          let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
          let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
        '';
      }
      { plugin = NeoSolarized;
        config = ''
          " terminal color normalization fixes
          if &term =~ '256color'
            " disable Background Color Erase (BCE) so that color schemes
            " render properly when inside 256-color tmux and GNU screen.
            " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
            set t_ut=
          endif
          let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
          let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
          set termguicolors

          set colorcolumn=100

          set background=light
          colorscheme NeoSolarized
        '';
      }

      # languages
      { plugin = vim-nix; }
      { plugin = vim-javascript; }
      { plugin = typescript-vim; }
      { plugin = vim-jsx-pretty; }
      { plugin = vim-mdx-js; }
      { plugin = vim-terraform; }
      { plugin = vim-racket; }
      { plugin = pkgs.parinfer-rust; }
      { plugin = vimtex; }
    ];
}
