if has("unix")
    if filereadable(glob("~/.config/nvim/ide.vim"))
        exe 'source' glob("~/.config/nvim/ide.vim")
    endif
elseif has("win32")
    if filereadable(glob("$HOMEPATH/AppData/Local/nvim/ide.vim"))
        if !exists('neovide')
            exe 'source' glob("$HOMEPATH/AppData/Local/nvim/ide.vim")
        endif
    endif
endif

let s:fontsize = 9
function! AdjustFontSize(amount)
  let s:fontsize = s:fontsize+a:amount
  if has("win32")
      set guifont="Consolas:h" . s:fontsize
  else
      set guifont="Source Code Pro:h" . s:fontsize
  endif
endfunction

" Font resize
noremap <silent> <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
noremap <silent> <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
inoremap <silent> <C-ScrollWheelUp> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <silent> <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a

nnoremap <silent> <C-+> :call AdjustFontSize(1)<CR>
nnoremap <silent> <C--> :call AdjustFontSize(-1)<CR>
inoremap <silent> <C-+> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <silent> <C--> <Esc>:call AdjustFontSize(-1)<CR>a

" Copy/paste
inoremap <silent> <S-Insert> <Esc>"+gPa
inoremap <silent> <M-v> <Esc>"+gPa
nnoremap <silent> <S-Insert> "+gPa
nnoremap <silent> <M-v> "+gPa
