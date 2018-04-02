filetype plugin on    " required
execute pathogen#infect()
syntax enable
set encoding=utf-8
set background=dark
colorscheme slate
set number
" set relativenumber
set wrap
set linebreak
set nolist  " list disables linebreak
set textwidth=0
set wrapmargin=0

""" CHANGING COLOURS
hi Normal ctermbg=none guibg=black
hi LineNr cterm=bold ctermbg=none ctermfg=white
hi Folded cterm=bold ctermfg=white ctermbg=none gui=bold guifg=white guibg=black
hi ModeMsg cterm=bold ctermfg=white
hi lCursor ctermbg=white ctermfg=black

""" RESIZING
	map .rk :res<space>+5<Enter>
	map .rj :res<space>-5<Enter>
	map .rh :vertical<space>resize<space>-5<Enter>
	map .rl :vertical<space>resize<space>+5<Enter>

""" FOR STATUS
set laststatus=2

" Find out current buffer's size and output it.
function! FileSize()
  let bytes = getfsize(expand('%:p'))
  if (bytes >= 1024)
    let kbytes = bytes / 1024
  endif
  if (exists('kbytes') && kbytes >= 1000)
    let mbytes = kbytes / 1000
  endif

  if bytes <= 0
    return '0'
  endif

  if (exists('mbytes'))
    return mbytes . 'MB '
  elseif (exists('kbytes'))
    return kbytes . 'KB '
  else
    return bytes . 'B '
  endif
endfunction

function! ReadOnly()
  if &readonly || !&modifiable
    return ''
  else
    return ''
endfunction

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set statusline=
set statusline+=%#lCursor#
set statusline+=\ /%F 
set statusline+=\ 
set statusline+=%#LineNr#
set statusline+=\ %-3(%{FileSize()}%) 
set statusline+=\ %{ReadOnly()}\ %m\ %w\ 
set statusline+=%=
set statusline+=\ %Y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ 
set statusline+=%#lCursor#
set statusline+=\ %p%%
set statusline+=\ L:
set statusline+=%l/
set statusline+=%L
set statusline+=\ C:
set statusline+=%c
set statusline+=\ 


""" LATEX-SUITE
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_CompileRule_pdf = 'pdflatex -interaction=nonstopmode -shell-escape $*'
let g:Tex_ViewRule_pdf = '/usr/bin/mupdf'
let g:Tex_MultipleCompileFormats='dvi,pdf,bibtex,pdf'
let g:Tex_BibtexFlavor = 'biber'

" The following is relevant to make LaTeX rerun after biber if necessary: 
" " (include all formats for which re-running is to be enabled)
" let g:Tex_MultipleCompileFormats='pdf,dvi'

"let g:Tex_FormatDependency_pdf = 'dvi,ps,pdf'
"let g:Tex_CompileRule_dvi = 'latex --interaction=nonstopmode $*'
"let g:Tex_CompileRule_ps = 'dvips -Ppdf -o $*.ps $*.dvi'
"let g:Tex_CompileRule_pdf = 'ps2pdf $*.ps'

" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
" set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
" filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
"set sw=2
" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:

" just pdflatex
	autocmd Filetype tex map \cp :!pdflatex<space>--shell-escape<space><C-r>%<Enter><Enter>

" MAKEINDEX
	autocmd Filetype tex map \mi :!makeindex<space><C-r>%<BS><BS><BS><BS>.nlo<space>-s<space>nomencl.ist<space>-o<space><C-r>%<BS><BS><BS><BS>.nls<Enter><Enter>
"makeindex main.nlo -s nomencl.ist -o main.nls

	autocmd FileType tex inoremap .bf \textbf{}<++><Esc>T{i
	autocmd FileType tex inoremap .it \textit{}<++><Esc>T{i
	autocmd FileType tex inoremap .tt \texttt{}<++><Esc>T{i
	autocmd FileType tex inoremap .sc \textsc{}<++><Esc>T{i
	autocmd FileType tex inoremap .ci \cite{}<++><Esc>T{i
	autocmd FileType tex inoremap .ct \citet{}<++><Esc>T{i
	autocmd FileType tex inoremap .cp \citep{}<++><Esc>T{i

	autocmd FileType tex inoremap .sec \section{}<Enter><Enter><++><Esc>2kf}i
	autocmd FileType tex inoremap .ssec \subsection{}<Enter><Enter><++><Esc>2kf}i
	autocmd FileType tex inoremap .sssec \subsubsection{}<Enter><Enter><++><Esc>2kf}i

	autocmd FileType tex inoremap .rf \ref{fig:}<Space><++><Esc>T:i
	autocmd FileType tex inoremap .rt \ref{tab:}<Space><++><Esc>T:i
	autocmd FileType tex inoremap .re \ref{eq:}<Space><++><Esc>T:i
	autocmd FileType tex inoremap .rs \ref{sec:}<Space><++><Esc>T:i
	autocmd FileType tex inoremap .rss \ref{ssec:}<Space><++><Esc>T:i

	autocmd FileType tex inoremap .lf \label{fig:}<Space><++><Esc>T:i
	autocmd FileType tex inoremap .lt \label{tab:}<Space><++><Esc>T:i
	autocmd FileType tex inoremap .le \label{eq:}<Space><++><Esc>T:i
	autocmd FileType tex inoremap .ls \label{sec:}<Space><++><Esc>T:i
	autocmd FileType tex inoremap .lss \label{ssec:}<Space><++><Esc>T:i

	autocmd FileType tex inoremap .bg \begin{DELRN}<Enter><++><Enter>\end{DELRN}<Enter><Enter><++><Esc>4k0fR:MultipleCursorsFind<Space>DELRN<Enter>c
	autocmd FileType tex inoremap .up \usepackage{}<++><Esc>T{i
	autocmd FileType tex inoremap .bm \begin{multicols}{2}<Enter><Enter><Enter><Enter>\end{multicols}<Enter><Enter><++><Esc>4k0fR
	autocmd FileType tex inoremap .str {\setstretch{<++>}<Enter><++><Enter><Enter>}<Enter><Enter><++><Esc>5k0fR<Esc>T:i

	autocmd FileType tex map \ob :sp<space><C-r>%<BS><BS><BS>bib<Enter>

""" MARKDOWN
	autocmd Filetype markdown map \cp :!pandoc<space><C-r>%<space>-o<space><C-r>%<BS><BS><BS>.pdf<Enter><Enter>
	autocmd Filetype markdown map \ch :!pandoc<space><C-r>%<space>--css<space>~/pandoc.css<space>-o<space><C-r>%<BS><BS><BS>.html<Enter><Enter>
	autocmd Filetype markdown map \cb :!pandoc<space><C-r>%<space>-t<space>beamer<space>-o<space><C-r>%<BS><BS><BS>beamer.pdf<Enter><Enter>
	autocmd Filetype rmd map \ll :!echo<space>"require(rmarkdown);<space>render('<c-r>%')"<space>\|<space>R<space>--vanilla<Enter><Enter>
	autocmd Filetype rmd inoremap ;r ```{r}<CR>```<CR><CR><esc>2kO
	autocmd Filetype rmd inoremap ;p ```{python}<CR>```<CR><CR><esc>2kO

""" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow
	set splitright

""" Distraction-free mode with Goyo!
	map .gy :Goyo<bar>hi<space>Normal<space>ctermbg=none<space>guibg=black<bar>hi<space>LineNr<space>cterm=bold<space>ctermbg=none<space>ctermfg=white<bar>hi<space>Folded<space>cterm=bold<space>ctermfg=white<space>ctermbg=none<bar>hi<space>ModeMsg<space>cterm=bold<space>ctermfg=white<bar>hi<space>lCursor<space>ctermbg=white<space>ctermfg=black<Enter><Enter>

""" PDF wordcount
	autocmd Filetype tex map \ps :!pdftops<space><C-r>%<BS><BS><BS>pdf<Enter><Enter>
	autocmd Filetype tex map \wc :!ps2ascii<space><C-r>%<BS><BS><BS>ps<bar>wc<space>-w<Enter>
	autocmd Filetype markdown map \ps :!pdftops<space><C-r>%<BS><BS>pdf<Enter><Enter>
	autocmd Filetype markdown map \wc :!ps2ascii<space><C-r>%<BS><BS>ps<bar>wc<space>-w<Enter>
	autocmd Filetype rmd map \ps :!pdftops<space><C-r>%<BS><BS><BS>pdf<Enter><Enter>
	autocmd Filetype rmd map \wc :!ps2ascii<space><C-r>%<BS><BS><BS>ps<bar>wc<space>-w<Enter>

""" Python
	autocmd Filetype python map \ll :w<space>!python<Enter>
