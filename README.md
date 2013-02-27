# Transit.app integration for VIM (Mac)
## Description
A simple vim plugin that lets you send the current file to
[Transmit](http://panic.com/transmit/), leveraging its "dropsend" feature. The
plugin also does a shallow search for compiled filetypes. For example, CSS
stylesheet compiled from [SCSS](http://sass-lang.com/),
[LESS](http://lesscss.org/) or [stylus](http://learnboost.github.com/stylus/).

## Installation

If you don't have a preferred installation method, I'd recommend
[Vundle](https://github.com/gmarik/vundle). Then you'd simply add this to your
vimrc:

    Bundle "hlissner/vim-transmitty"

Then restart and run:

    :BundleInstall

## Requirements

This should go without saying: this is MAC ONLY. You also need
[Transmit](http://panic.com/transmit/) in your /Applications folder.

## Usage

The plugin provides two simple shortcuts:

    <leader>ou       " Send this file to Transmit"
    <leader>oU       " Send this file to Transmit (but don't look for compiled files)

It will search for compiled files for any filetype that's been registered in the
g:transmittyLookupExts dictionary. These are the provided defaults:

    let g:transmittyLookupExts = {
        'sass':     ['../css', 'css'],
        'scss':     ['../css', 'css'],
        'less':     ['../css', 'css'],
        'stylus':   ['../css', 'css'],
        'haml':     ['../', 'html'],
        'jade':     ['../', 'html'],
        'slim':     ['../', 'html'],
        'coffee':   ['../js', 'min.js'],
    }

If you'd like to set/add your own:

    " folder_to_search is relative to the open file
    let g:transmittyLookupExts["filetype"] = ["folder_to_search", "extension"]

## Recommendations

I'd recommend [LiveReload](http://livereload.com/) and
[CodeKit](http://incident57.com/codekit/) to "watch" and compile your code when
you save.

This plugin's a part of my [VIM distro for spaghetti code
warriors](https://github.com/hlissner/mlvim).
