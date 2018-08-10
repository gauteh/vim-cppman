" This is essentially an adapted version of the cppman.vim script that is 
" included with cppman. Authored by Wei-Ning Huang (AZ) <aitjcize@gmail.com>
" and others.
"
"
" This program is free software; you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation; either version 3 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program; if not, write to the Free Software Foundation,
" Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


function! BackToPrevPage()
  if len(g:stack) > 0
    let context = g:stack[-1]
    call remove(g:stack, -1)
    let g:page_name = context[0]
    call s:reload()
    call setpos('.', context[1])
  end
endfunction

function! s:reload()
  setl noro
  setl ma
  echo "Loading..."
  exec "%d"
  exec "0r! cppman --force-columns " . (winwidth(0) - 2) . " '" . g:page_name . "'"
  setl ro
  setl noma
  setl nomod
endfunction

function! s:Rerender()
  if winwidth(0) != s:old_col
    let s:old_col = winwidth(0) 
    let save_cursor = getpos(".")
    call s:reload()
    call setpos('.', save_cursor)
  end
endfunction

function! LoadNewPage()
  " Save current page to stack
  call add(g:stack, [g:page_name, getpos(".")])
  let g:page_name = expand("<cword>")
  setl noro
  setl ma
  call s:reload()
  normal! gg
  setl ro
  setl noma
  setl nomod
endfunction

function! s:Cppman(page)
  vertical bo new
  setlocal buftype=nofile
  setlocal bufhidden=delete
  setlocal noswapfile

  let g:page_name = a:page

  setl nonu
  setl nornu
  setl noma
  noremap <buffer> q :q!<CR>

  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif

  syntax on
  syntax case ignore
  syntax match  manReference       "[a-z_:+-\*][a-z_:+-~!\*<>]\+([1-9][a-z]\=)"
  syntax match  manTitle           "^\w.\+([0-9]\+[a-z]\=).*"
  syntax match  manSectionHeading  "^[a-z][a-z_ \-:]*[a-z]$"
  syntax match  manSubHeading      "^\s\{3\}[a-z][a-z ]*[a-z]$"
  syntax match  manOptionDesc      "^\s*[+-][a-z0-9]\S*"
  syntax match  manLongOptionDesc  "^\s*--[a-z0-9-]\S*"

  syntax include @cppCode runtime! syntax/cpp.vim
  syntax match manCFuncDefinition  display "\<\h\w*\>\s*("me=e-1 contained

  syntax region manSynopsis start="^SYNOPSIS"hs=s+8 end="^\u\+\s*$"me=e-12 keepend contains=manSectionHeading,@cppCode,manCFuncDefinition
  syntax region manSynopsis start="^EXAMPLE"hs=s+7 end="^       [^ ]"he=s-1 keepend contains=manSectionHeading,@cppCode,manCFuncDefinition

  " Define the default highlighting.
  " For version 5.7 and earlier: only when not done already
  " For version 5.8 and later: only when an item doesn't have highlighting yet
  if version >= 508 || !exists("did_man_syn_inits")
    if version < 508
      let did_man_syn_inits = 1
      command -nargs=+ HiLink hi link <args>
    else
      command -nargs=+ HiLink hi def link <args>
    endif

    HiLink manTitle	    Title
    HiLink manSectionHeading  Statement
    HiLink manOptionDesc	    Constant
    HiLink manLongOptionDesc  Constant
    HiLink manReference	    PreProc
    HiLink manSubHeading      Function
    HiLink manCFuncDefinition Function

    delcommand HiLink
  endif

  """ Vim Viewer
  setl mouse=a
  setl colorcolumn=0


  let g:stack = []

  noremap <buffer> K :call LoadNewPage()<CR>
  map <buffer> <CR> K
  map <buffer> <C-]> K
  map <buffer> <2-LeftMouse> K

  noremap <buffer> <C-o> :call BackToPrevPage()<CR>
  map <buffer> <RightMouse> <C-o>

  let b:current_syntax = "man"

  let s:old_col = 0 
  autocmd VimResized * call s:Rerender()

  " Open page
  call s:reload()
  exec "0"
endfunction

command! -nargs=+ Cppman call s:Cppman(expand(<q-args>)) 
setl keywordprg=:Cppman                                  
setl iskeyword+=:,=,~,[,],*,!,<,>                        

