if has("unix")
    if filereadable(glob("~/.config/nvim/ide.vim"))
        exe 'source' glob("~/.config/nvim/ide.vim")
    endif
elseif has("win32")
    if filereadable(glob("$HOMEPATH/AppData/Local/nvim/ide.vim"))
        exe 'source' glob("$HOMEPATH/AppData/Local/nvim/ide.vim")
    endif
endif
