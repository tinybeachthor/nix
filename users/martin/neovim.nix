{ pkgs, ... }:

{
  enable = true;

  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;

  withRuby = true;
  withPython3 = true;
  extraPython3Packages = p: with p; [ jedi ];
  withNodeJs = true;

  extraConfig = builtins.readFile ./neovim.vim;

  extraPackages = with pkgs; [
    git

    # fzf-vim
    fzf
    ripgrep
    bat
    delta
  ];

  coc = {
    enable = true;
    package = pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "coc.nvim";
      version = "2022-05-21";
      src = pkgs.fetchFromGitHub {
        owner = "neoclide";
        repo = "coc.nvim";
        rev = "791c9f673b882768486450e73d8bda10e391401d";
        sha256 = "sha256-MobgwhFQ1Ld7pFknsurSFAsN5v+vGbEFojTAYD/kI9c=";
      };
      meta.homepage = "https://github.com/neoclide/coc.nvim/";
    };
    settings = {
      "coc.preferences.formatOnType" = false;
      "coc.preferences.jumpCommand" = "edit";

      "markdownlint.config" = {
        "MD013" = false;
      };

      "eslint.enable" = true;
      "eslint.run" = "onType";

      "rust-client.disableRustup" = true;

      languageserver = {
        haskell = {
          command = "haskell-language-server-wrapper";
          args = ["--lsp"];
          rootPatterns = [
            "*.cabal"
            "stack.yaml"
            "cabal.project"
            "package.yaml"
            "hie.yaml"
            ".git/"
          ];
          filetypes = ["haskell" "lhaskell" "hs" "lhs"];
        };
        racket = {
          filetypes = ["racket"];
          command = "racket -l racket-langserver";
          rootPatterns = ["info.rkt" ".git/"];
        };
      };
    };
    pluginConfig = ''
      let mapleader = "\<space>"

      set hidden
      set cmdheight=2
      set updatetime=250
      set signcolumn=yes

      " Use <C-j> for both expand and jump (make expand higher priority.)
      imap <C-j> <Plug>(coc-snippets-expand-jump)
      " Use <leader>x for convert visual selected code to snippet
      xmap <leader>x  <Plug>(coc-convert-snippet)

      " use <tab> for trigger completion and navigate next complete item
      function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~ '\s'
      endfunction

      inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()

      " Use <c-space> for trigger completion.
      inoremap <silent><expr> <c-space> coc#refresh()

      " Use <C-x><C-o> to complete 'word', 'emoji' and 'include' sources
      imap <silent> <C-x><C-o> <Plug>(coc-complete-custom)

      " close completion window on done
      autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

      " Remap for rename current word
      nmap <leader>rn <Plug>(coc-rename)

      " Navigate diagnostics
      nmap <silent> [g <Plug>(coc-diagnostic-prev)
      nmap <silent> ]g <Plug>(coc-diagnostic-next)

      " Remap keys for gotos
      nmap <silent> gd <Plug>(coc-definition)
      nmap <silent> gy <Plug>(coc-type-definition)
      nmap <silent> gi <Plug>(coc-implementation)
      nmap <silent> gr <Plug>(coc-references)

      " Show signature help while editing
      autocmd CursorHoldI * silent! call CocActionAsync('showSignatureHelp')
      " Highlight symbol under cursor on CursorHold
      autocmd CursorHold * silent call CocActionAsync('highlight')

      " Remap for format selected region
      vmap <leader>cf <Plug>(coc-format-selected)
      nmap <leader>cf <Plug>(coc-format-selected)

      " don't give |ins-completion-menu| messages.
      set shortmess+=c

      " Use K to show documentation in preview window
      nnoremap <silent> K :call <SID>show_documentation()<CR>
      function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
          execute 'h '.expand('<cword>')
        else
          call CocAction('doHover')
        endif
      endfunction

      " Use `:Format` for format current buffer
      command! -nargs=0 Format :call CocAction('format')
      " Use `:Fold` for fold current buffer
      command! -nargs=? Fold :call CocAction('fold', <f-args>)

      " enable symbol highlighting
      autocmd CursorHold * silent call CocActionAsync('highlight')
      " set symbol highlight color
      highlight CocHighlightText cterm=bold ctermfg=Yellow gui=bold guifg=#ff8229

      " Create mappings for function text object, requires document symbols feature of languageserver.
      xmap if <Plug>(coc-funcobj-i)
      xmap af <Plug>(coc-funcobj-a)
      omap if <Plug>(coc-funcobj-i)
      omap af <Plug>(coc-funcobj-a)

      " use `:OR` for organize import of current buffer
      command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

      " Add status line support, for integration with other plugin, checkout `:h coc-status`
      set statusline^=%{coc#status()}%{get(b:,'coc_current_function',\'\')}

      " Keymappings

      " Remap for format selected region
      xmap <leader>f <Plug>(coc-format-selected)
      nmap <leader>f <Plug>(coc-format-selected)

      nnoremap <silent> <leader>d  :<C-u>CocAction<CR>

      nnoremap <silent> <leader>ca  :<C-u>CocList actions<CR>
      nnoremap <silent> <leader>cv  :<C-u>CocList vimcommands<CR>
      nnoremap <silent> <leader>cc  :<C-u>CocList cmdhistory<CR>
      nnoremap <silent> <leader>cr  :<C-u>CocList mru<CR>
    '';
  };

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
      { plugin = vim-sneak; }
      { plugin = vim-abolish; }
      { plugin = vim-speeddating; }
      { plugin = tabular; }

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
      { plugin = vim-jsx-pretty; }
      { plugin = typescript-vim; }
      { plugin = haskell-vim; }
      { plugin = vim-go; }
      { plugin = Jenkinsfile-vim-syntax; }
      { plugin = vim-mdx-js; }
      { plugin = vim-terraform; }
      { plugin = vim-racket; }
      { plugin = pkgs.parinfer-rust; }
      { plugin = vimtex; }
    ];
}
