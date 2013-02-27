# Transit.app integration for VIM (Mac)
*This is a part of my [VIM distro for spaghetti code
warriors](https://github.com/hlissner/mlvim).*

## Description
A simple vim plugin that lets you send the current file to
[Transmit](http://panic.com/transmit/), leveraging its "dropsend" feature. The
plugin also does a shallow search for for filetypes that are compiled. For
example, CSS stylesheet compiled from [SCSS](http://sass-lang.com/),
[LESS](http://lesscss.org/) or [stylus](http://learnboost.github.com/stylus/).

Should go without saying: this is **only for macs**.


## Requirements

Should go without saying that this is **MAC ONLY**.

Also, you need [Transmit](http://panic.com/transmit/) in your /Applications
folder.

## Usage

Simply, the plugin provides two shortcuts:

    <leader>u       " Send this file to Transmit"
    <leader>U       " Send this file to Transmit (but don't look for compiled files)

Regarding where the plugin looks for compiled files, the following defaults are set:

    let g:transmittyLookupExts = {
        'sass':         ['../css', 'css'],
        'scss':         ['../css', 'css'],
        'less':         ['../css', 'css'],
        'stylus':       ['../css', 'css'],
        'haml':         ['../', 'html'],
        'jade':         ['../', 'html'],
        'slim':         ['../', 'html'],
        'coffeescript': ['../js', 'min.js'],
    }

To set your own:

    " folder_to_search is relative to the open file
    let g:transmittyLookupExts["filetype"] = ["folder_to_search", "extension"]
