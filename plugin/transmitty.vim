" *vim-transmitty* Integrating Transmit and vim
"
" Version: 0.0.1
" Author: Henrik Lissner <henrik at lissner.net>
" URL: https://github.com/hlissner/vim-transmitty

if exists('g:loadedTransmitty')
    finish
endif
let g:loadedTransmitty = 1


"""""""""""""""
"  FUNCTIONS  "
"""""""""""""""
" Try to send the currently open file to Transmit!
func! s:upload(force_no_lookup)
    let filepath = a:force_no_lookup == 1 ? expand('%:p') : s:findFile()
    if strlen(filepath) == 0
        echoe "Could not find the file! (Was it saved/compiled?)"
        return
    endif

    silent exec '!open -a Transmit '.shellescape(filepath)
    echom "Uploaded: ".split(filepath, '/')[-1]
endfunc

" See if this is one of the "lookup" extensions, and if it is, find the real
" file we're meant to send to Transmit.
func! s:findFile()
    let currentfile = expand("%:p")

    if strlen(currentfile) == 0
        return ""
    endif

    let ext = expand("%:e")
    if has_key(g:transmittyLookupExts, ext)
        let lookup = g:transmittyLookupExts[ext]

        let dir  = expand("%:p:h")
        let base = expand("%:t:r")

        " Find/set the new directory
        let dir = resolve(expand(lookup[0][0] == '/' ? lookup[0] : dir.'/'.lookup[0]))

        " Find/set the new file extension
        if strlen(get(lookup, 1, "")) > 0
            let ext = lookup[1]
        endif

        return dir . '/' . base . '.' . ext
    else
        return currentfile
    endif
endfunc

" Defines a path. If it already exists it won't overwrite it. (Used internally)
func! s:definePath(filetype, path)
    if !has_key(g:transmittyLookupExts, a:filetype)
        let g:transmittyLookupExts[a:filetype] = a:path
    endif
endfunc


""""""""""""""
"  DEFAULTS  "
""""""""""""""
if !exists('g:transmittyNoMappings')
    let g:transmittyNoMappings = 0
endif

if !exists('g:transmittyLookupExts')
    let g:transmittyLookupExts = {}
endif

call s:definePath('sass',       ['../css', 'css'])
call s:definePath('scss',       ['../css', 'css'])
call s:definePath('less',       ['../css', 'css'])
call s:definePath('stylus',     ['../css', 'css'])
call s:definePath('haml',       ['../', 'html'])
call s:definePath('jade',       ['../', 'html'])
call s:definePath('slim',       ['../', 'html'])
call s:definePath('coffee',     ['../js', 'min.js'])


""""""""""""""
"  MAPPINGS  "
""""""""""""""
map <Plug>TransmittyUploadLook :<C-U>call <SID>upload(0)<CR>
map <Plug>TransmittyUploadNoLook :<C-U>call <SID>upload(1)<CR>

if g:transmittyNoMappings != 1
    " Upload current file (check paths)
    map <leader>u <Plug>TransmittyUploadLook
    " Upload the current file (no lookup)
    map <leader>U <Plug>TransmittyUploadNoLook
endif
