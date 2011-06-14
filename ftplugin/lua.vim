" Vim file type plug-in
" Language: Lua 5.1
" Author: Peter Odding <peter@peterodding.com>
" Last Change: June 14, 2011
" URL: http://peterodding.com/code/vim/lua-ftplugin
" Version: 0.5.6

if exists('b:did_ftplugin')
  finish
else
  let b:did_ftplugin = 1
endif

" A list of commands that undo buffer local changes made below.
let s:undo_ftplugin = []

" Set comment (formatting) related options. {{{1
setlocal fo-=t fo+=c fo+=r fo+=o fo+=q fo+=l
setlocal cms=--%s com=s:--[[,m:\ ,e:]],:--
call add(s:undo_ftplugin, 'setlocal fo< cms< com<')

" Tell Vim how to follow dofile(), loadfile() and require() calls. {{{1
let &l:include = '\v<((do|load)file|require)[^''"]*[''"]\zs[^''"]+'
let &l:includeexpr = 'xolox#lua#includeexpr(v:fname)'
call add(s:undo_ftplugin, 'setlocal inc< inex<')

" Enable completion of Lua keywords, globals and library members. {{{1
setlocal completefunc=xolox#lua#completefunc
call add(s:undo_ftplugin, 'setlocal completefunc<')

" Set a filename filter for the Windows file open/save dialogs. {{{1
if has('gui_win32') && !exists('b:browsefilter')
  let b:browsefilter = "Lua Files (*.lua)\t*.lua\nAll Files (*.*)\t*.*\n"
  call add(s:undo_ftplugin, 'unlet! b:browsefilter')
endif

" Enable automatic command to check for syntax errors when saving buffers. {{{1
augroup PluginFileTypeLua
  autocmd! BufWritePost <buffer> call xolox#lua#checksyntax()
  call add(s:undo_ftplugin, 'autocmd! PluginFileTypeLua BufWritePost <buffer>')
augroup END

" Define mappings for context-sensitive help using Lua Reference for Vim. {{{1
imap <buffer> <F1> <C-o>:call xolox#lua#help()<Cr>
nmap <buffer> <F1>      :call xolox#lua#help()<Cr>
call add(s:undo_ftplugin, 'iunmap <buffer> <F1>')
call add(s:undo_ftplugin, 'nunmap <buffer> <F1>')

" Define custom text objects to navigate Lua source code. {{{1
noremap <buffer> <silent> [{ m':call xolox#lua#jumpblock(0)<Cr>
noremap <buffer> <silent> ]} m':call xolox#lua#jumpblock(1)<Cr>
noremap <buffer> <silent> [[ m':call xolox#lua#jumpthisfunc(0)<Cr>
noremap <buffer> <silent> ][ m':call xolox#lua#jumpthisfunc(1)<Cr>
noremap <buffer> <silent> [] m':call xolox#lua#jumpotherfunc(0)<Cr>
noremap <buffer> <silent> ]] m':call xolox#lua#jumpotherfunc(1)<Cr>
call add(s:undo_ftplugin, 'unmap <buffer> [{')
call add(s:undo_ftplugin, 'unmap <buffer> ]}')
call add(s:undo_ftplugin, 'unmap <buffer> [[')
call add(s:undo_ftplugin, 'unmap <buffer> ][')
call add(s:undo_ftplugin, 'unmap <buffer> []')
call add(s:undo_ftplugin, 'unmap <buffer> ]]')

" Enable extended matching with "%" using the "matchit" plug-in. {{{1
if exists('loaded_matchit')
  let b:match_ignorecase = 0
  let b:match_words = 'xolox#lua#matchit()'
  call add(s:undo_ftplugin, 'unlet! b:match_ignorecase b:match_words b:match_skip')
endif

" Enable dynamic completion on typing the "." operator? {{{1
imap <buffer> <silent> <expr> . xolox#lua#completedynamic()
call add(s:undo_ftplugin, 'iunmap <buffer> .')

" }}}1

" Let Vim know how to disable the plug-in.
call map(s:undo_ftplugin, "'execute ' . string(v:val)")
let b:undo_ftplugin = join(s:undo_ftplugin, ' | ')
unlet s:undo_ftplugin

" vim: ts=2 sw=2 et
