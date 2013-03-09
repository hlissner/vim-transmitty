" *vim-transmitty* Integrating Transmit and vim
"
" Author: Henrik Lissner <henrik at lissner.net>
" URL: https://github.com/hlissner/vim-transmitty

if exists('g:loaded_transmitty')
    finish
endif
let g:loaded_transmitty = 1

"""""""""""""""""""""
" Settings {{

    if !exists('g:transmitty_no_mappings')
        let g:transmitty_no_mappings = 0
    endif

    if !exists('g:transmitty_lookup_exts')
        let g:transmitty_lookup_exts = {}
    endif

    let s:script_base = expand("<sfile>:p:h:h")

" }}


"""""""""""""""""""""
" Core {{

    " upload(no_lookup) {{
    " Try to send the currently open file to Transmit!
    func! s:upload(no_lookup)
        let filepath = s:findFile(a:no_lookup)
        if !filereadable(filepath)
            echoe "Could not find the file! Was it saved/compiled?"
            echoe "Checked: ".filepath
            return
        endif

        let applescript = s:script_base . "/apple/send_to_transmit.applescript"
        silent exec '!osascript '.shellescape(applescript). ' '.shellescape(filepath)
        echom "File sent to Transmit: ".split(filepath, '/')[-1]
    endfunc
    " }}

    " findFile() {{
    " See if this is one of the "lookup" extensions, and if it is, find the real
    " file we're meant to send to Transmit.
    func! s:findFile(no_lookup)
        let currentfile = expand("%:p")
        if currentfile ==# ""
            return ""
        endif

        let ext = expand("%:e")
        if a:no_lookup == 1 || !has_key(g:transmitty_lookup_exts, ext)
            return currentfile
        else
            let lookup = g:transmitty_lookup_exts[ext]

            let dir  = expand("%:p:h")
            let base = expand("%:t:r")

            " Find/set the new directory
            let dir = resolve(expand(lookup[0][0] == '/' ? lookup[0] : dir.'/'.lookup[0]))

            " Find/set the new file extension
            if strlen(get(lookup, 1, "")) > 0
                let ext = lookup[1]
            endif

            return dir . '/' . base . '.' . ext
        endif
    endfunc
    " }}

    " definePath(filetype, path) {{
    " Defines a path. If it already exists it won't overwrite it. (Used internally)
    func! s:definePath(filetype, path)
        if !has_key(g:transmitty_lookup_exts, a:filetype)
            let g:transmitty_lookup_exts[a:filetype] = a:path
        endif
    endfunc
    " }}

" }}


"""""""""""""""""""""
" Bootstrap {{

call s:definePath('sass',       ['../css', 'css'])
call s:definePath('scss',       ['../css', 'css'])
call s:definePath('less',       ['../css', 'css'])
call s:definePath('stylus',     ['../css', 'css'])
call s:definePath('haml',       ['../', 'html'])
call s:definePath('jade',       ['../', 'html'])
call s:definePath('slim',       ['../', 'html'])
call s:definePath('coffee',     ['../js', 'min.js'])

map <Plug>TransmittyUploadLook :<C-U>call <SID>upload(0)<CR>
map <Plug>TransmittyUploadNoLook :<C-U>call <SID>upload(1)<CR>

let os = substitute(system("uname -s"), '\n', '', '')
if g:transmitty_no_mappings != 1 && os ==# "Darwin"
    " Upload current file (check paths)
    nmap <leader>ou <Plug>TransmittyUploadLook
    " Upload the current file (no lookup)
    nmap <leader>oU <Plug>TransmittyUploadNoLook
endif

" }}

" vim: set foldmarker={{,}} foldlevel=0 foldmethod=marker
